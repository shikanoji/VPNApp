//
//  WireGuardViewController.swift
//  SysVPN
//
//  Created by Da Phan Van on 19/04/2022.
//

import Foundation
import UIKit
import TunnelKitWireGuard
import TunnelKit
import NetworkExtension

private let appGroup = "group.sysvpn.client.ios"

#if DEBUG
private let tunnelIdentifier = "com.sysvpn.client.ios.dev.wireguard"
#else
private let tunnelIdentifier = "com.sysvpn.client.ios.wireguard"
#endif

class WireGuardManager: ObservableObject {
    
    private let vpn = NetworkExtensionVPN()
    
    private var vpnStatus: VPNStatus = .disconnected
    
    static var shared = WireGuardManager()
    private var cfg: WireGuard.ProviderConfiguration?
    
    func connect(_ obtainCer: ObtainCertificateModel?) async {
        if let obtainCer = obtainCer,
           let cfgParase = configuretionParaseFromContents(obtainCer) {
            cfg = cfgParase
            
            var extra = NetworkExtensionExtra()
            extra.onDemandRules = []

            do {
                try await vpn.reconnect(
                    tunnelIdentifier,
                    configuration: cfgParase,
                    extra: extra,
                    after: .seconds(2)
                )
            } catch {
                print(error)
                postError()
            }
        } else {
            postError()
        }
    }
    
    init() {
        Task {
            await vpn.prepare()
        }
    }
    
    func postError() {
        NotificationCenter.default.post(name: Notification.Name("vpnDidFailConfig"), object: nil)
    }
    
    func disconnect() async {
        await vpn.disconnect()
    }
    
    func configuretionParaseFromContents(_ obtainCer: ObtainCertificateModel) -> WireGuard.ProviderConfiguration? {
        let lines = obtainCer.convertToString().trimmedLines()
        
        var clientPrivateKey = ""
        var clientAddress = ""
        var dns = ""
        
        var serverPublicKey = ""
        var allowedIPs = ""
        var endPoint = ""
        
        for line in lines {
            if let privateKey = getValueParase(line, regexType: Regex.privateKey) {
                clientPrivateKey = privateKey
            }
            
            if let address = getValueParase(line, regexType: Regex.address) {
                clientAddress = address
            }
            
            if let dnsParase = getValueParase(line, regexType: Regex.dns) {
                dns = dnsParase
            }
            
            if let publicKey = getValueParase(line, regexType: Regex.publicKey) {
                serverPublicKey = publicKey
            }
            
            if let allowedIPsParase = getValueParase(line, regexType: Regex.allowedIPs) {
                allowedIPs = allowedIPsParase
            }
            
            if let endpoint = getValueParase(line, regexType: Regex.endpoint) {
                endPoint = endpoint
            }
        }
        
        do {
            var builder = try WireGuard.ConfigurationBuilder(clientPrivateKey)
            builder.addresses = [clientAddress]
            
            if AppSetting.shared.selectCyberSec, !obtainCer.dns.isEmpty {
                builder.dnsServers = obtainCer.dns
            } else {
                builder.dnsServers = getCustomDNS().count > 0 ? getCustomDNS() : [dns]
            }
            
            try builder.addPeer(serverPublicKey, endpoint: endPoint, allowedIPs: [allowedIPs])
            builder.addAllowedIP(allowedIPs, toPeer: 0)
            
            var cfg = builder.build()
            cfg.paramGetCert = AppSetting.shared.paramGetCert
            cfg.headerGetCert = AppSetting.shared.headerGetCert
            
            return WireGuard.ProviderConfiguration("WireGuard", appGroup: appGroup, configuration: cfg)
        } catch {
            print(error)
        }
        
        return nil
    }
    
    func getCustomDNS() -> [String] {
        var dnsList: [String] = []
        
        guard let dnsCyberSec = AppSetting.shared.obtainCertificate?.dns,
              !dnsCyberSec.isEmpty else {
            if AppSetting.shared.primaryDNSValue != "" {
                dnsList.append(AppSetting.shared.primaryDNSValue)
            }
            if AppSetting.shared.secondaryDNSValue != "" {
                dnsList.append(AppSetting.shared.secondaryDNSValue)
            }
            return dnsList
        }
        return dnsCyberSec
    }
    
    func getValueParase(_ line: String, regexType: NSRegularExpression) -> String? {
        var valueParase: String? = nil
        regexType.enumerateArguments(in: line) {
            if $0.count > 1 {
                valueParase = $0[1]
            }
        }
        return valueParase
    }
    
    struct Regex {
        static let privateKey = NSRegularExpression("PrivateKey = (.*)")
        static let address = NSRegularExpression("Address = (.*)")
        static let dns = NSRegularExpression("DNS = +[\\d\\.]+( +[\\d\\.]+){0,2}")
        static let publicKey = NSRegularExpression("PublicKey = (.*)")
        static let allowedIPs = NSRegularExpression("AllowedIPs = (.*)")
        static let endpoint = NSRegularExpression("Endpoint = (.*)")
    }
}

extension NSRegularExpression {
    public convenience init(_ pattern: String) {
        try! self.init(pattern: pattern, options: [])
    }
    
    public func enumerateComponents(in string: String, using block: ([String]) -> Void) {
        enumerateMatches(in: string, options: [], range: NSMakeRange(0, string.count)) { (result, flags, stop) in
            guard let range = result?.range else {
                return
            }
            let match = (string as NSString).substring(with: range)
            let tokens = match.components(separatedBy: " ").filter { !$0.isEmpty }
            block(tokens)
        }
    }
    
    public func enumerateArguments(in string: String, using block: ([String]) -> Void) {
        enumerateComponents(in: string) { (tokens) in
            var args = tokens
            args.removeFirst()
            block(args)
        }
    }
}

extension String {
    func trimmedLines() -> [String] {
        return components(separatedBy: .newlines).map {
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: "\\s", with: " ", options: .regularExpression)
        }.filter {
            !$0.isEmpty
        }
    }
}

