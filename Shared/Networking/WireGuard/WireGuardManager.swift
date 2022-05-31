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

private let appGroup = "group.com.ilg.SysVPN.dev.daz"

private let tunnelIdentifier = "com.ilg.SysVPN.dev.daz.WireGuard"

class WireGuardManager: ObservableObject {
    
    private let vpn = NetworkExtensionVPN()
    
    private var vpnStatus: VPNStatus = .disconnected
    
    static var shared = WireGuardManager()
    private var cfg: WireGuard.ProviderConfiguration?
    
    func connect() {
        let string = NetworkManager.shared.obtainCertificate?.convertToString()
        cfg = configuretionParaseFromContents(lines: string!.trimmedLines())
        
        Task {
            try await vpn.reconnect(
                tunnelIdentifier,
                configuration: cfg!,
                extra: nil,
                after: .seconds(2)
            )
        }
        
        x()
    }
    
    func x() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            
            self.x()
        }
    }
    
    init() {
        Task {
            await vpn.prepare()
        }
    }
    
    func disconnect() {
        Task {
            await vpn.disconnect()
        }
    }
    
    func configuretionParaseFromContents(lines: [String]) -> WireGuard.ProviderConfiguration? {
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
            builder.dnsServers = [dns]
            
            try builder.addPeer(serverPublicKey, endpoint: endPoint)
            builder.addAllowedIP(allowedIPs, toPeer: 0)
            
            let cfg = builder.build()
            
            return WireGuard.ProviderConfiguration("WireGuard", appGroup: appGroup, configuration: cfg)
        } catch {
            print(error)
        }
        
        return nil
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

