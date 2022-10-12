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

extension SystemDataUsage {
    
    public static var dataSent: UInt64 {
        return SystemDataUsage.getDataUsage().dataSent
    }
    
    public static var dataReceived: UInt64 {
        return SystemDataUsage.getDataUsage().dataReceived
    }
}

class SystemDataUsage {

    class func getDataUsage() -> DataUsageInfo {
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        var dataUsageInfo = DataUsageInfo()

        guard getifaddrs(&ifaddr) == 0 else { return dataUsageInfo }
        while let addr = ifaddr {
            guard let info = getDataUsageInfo(from: addr) else {
                ifaddr = addr.pointee.ifa_next
                continue
            }
            dataUsageInfo.updateInfoByAdding(info)
            ifaddr = addr.pointee.ifa_next
        }

        freeifaddrs(ifaddr)

        return dataUsageInfo
    }

    private class func getDataUsageInfo(from infoPointer: UnsafeMutablePointer<ifaddrs>) -> DataUsageInfo? {
        let pointer = infoPointer
        let name: String! = String(cString: pointer.pointee.ifa_name)
        let addr = pointer.pointee.ifa_addr.pointee
        guard addr.sa_family == UInt8(AF_LINK) else { return nil }

        return dataUsageInfo(from: pointer, name: name)
    }

    private class func dataUsageInfo(from pointer: UnsafeMutablePointer<ifaddrs>, name: String) -> DataUsageInfo {
        var networkData: UnsafeMutablePointer<if_data>?
        var dataUsageInfo = DataUsageInfo()
        
        networkData = unsafeBitCast(pointer.pointee.ifa_data, to: UnsafeMutablePointer<if_data>.self)
        if let data = networkData {
            dataUsageInfo.dataSent += UInt64(data.pointee.ifi_obytes)
            dataUsageInfo.dataReceived += UInt64(data.pointee.ifi_ibytes)
        }
        
        return dataUsageInfo
    }
}

struct DataUsageInfo {
    var dataReceived: UInt64 = 0
    var dataSent: UInt64 = 0

    mutating func updateInfoByAdding(_ info: DataUsageInfo) {
        dataReceived += info.dataReceived
        dataSent += info.dataSent
    }
}

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
    private var cfg: WireGuard.ProviderConfiguration!
    
    func connect() {
        let string = NetworkManager.shared.obtainCertificate?.convertToString() ?? ""
        if let cfgStr = configuretionParaseFromContents(lines: string.trimmedLines()) {
            self.cfg = cfgStr
            Task {
                do {
                    try await vpn.reconnect(
                        tunnelIdentifier,
                        configuration: cfgStr,
                        extra: nil,
                        after: .seconds(2)
                    )
                } catch {
                    print(error)
                    postError()
                }
            }
        }
    }
    
    init() {
        Task {
            await vpn.prepare()
        }
    }
    
    func postError() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Constant.NameNotification.connectVPNError, object: nil)
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
            builder.dnsServers = getCustomDNS().count > 0 ? getCustomDNS() : [dns]
            
            try builder.addPeer(serverPublicKey, endpoint: endPoint, allowedIPs: [allowedIPs])
            builder.addAllowedIP(allowedIPs, toPeer: 0)
            
            let cfg = builder.build()
            
            return WireGuard.ProviderConfiguration("WireGuard", appGroup: appGroup, configuration: cfg)
        } catch {
            print(error)
        }
        
        return nil
    }
    
    func getCustomDNS() -> [String] {
        var dnsList: [String] = []
        
        guard let dnsCyberSec = NetworkManager.shared.requestCertificate?.dns,
              dnsCyberSec.count > 0 else {
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

