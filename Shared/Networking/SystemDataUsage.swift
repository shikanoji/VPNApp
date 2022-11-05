//
//  NetworkAppStates.swift
//  SysVPN
//
//  Created by Da Phan Van on 03/11/2022.
//

import Foundation

class SystemDataUsage {
    private static var vpnInterfaces: [String]?
    static var lastestVpnUsageInfo: SingleDataUsageInfo = .init(received: 0, sent: 0)
     
    class func vpnDataUsageInfo() async -> SingleDataUsageInfo {
        var dataUsageInfo = SingleDataUsageInfo()
        var vpnInterface: [String] = []
        if let interfaces = vpnInterfaces {
            vpnInterface = interfaces
        } else {
            if let settings = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? [String: Any],
               let scopes = settings["__SCOPED__"] as? [String: Any] {
                for (key, _) in scopes {
                    if key.contains("tap") || key.contains("tun") || key.contains("ppp") || key.contains("ipsec") {
                        vpnInterface.append(key)
                    }
                }
            }
        }
        
        if vpnInterfaces == nil && !vpnInterface.isEmpty {
            vpnInterfaces = vpnInterface
        }
         
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return dataUsageInfo }
        while let pointer = ifaddr {
            let name: String! = String(cString: pointer.pointee.ifa_name)
            let addr = pointer.pointee.ifa_addr.pointee
            guard addr.sa_family == UInt8(AF_LINK) else {
                ifaddr = pointer.pointee.ifa_next
                continue
            }
            if !vpnInterface.contains(name) {
                ifaddr = pointer.pointee.ifa_next
                continue
            }
            
            var networkData: UnsafeMutablePointer<if_data>?
            networkData = unsafeBitCast(pointer.pointee.ifa_data, to: UnsafeMutablePointer<if_data>.self)
            if let data = networkData {
                let send = UInt64(data.pointee.ifi_obytes)
                let received = UInt64(data.pointee.ifi_ibytes)
                dataUsageInfo.received += received
                dataUsageInfo.sent += send
            }
            ifaddr = pointer.pointee.ifa_next
        }
        
        freeifaddrs(ifaddr)
        lastestVpnUsageInfo = dataUsageInfo
        return dataUsageInfo
    }
}

struct SingleDataUsageInfo {
    var received: UInt64 = 0
    var sent: UInt64 = 0
    
    mutating func updateInfoByAdding(_ info: SingleDataUsageInfo) {
        received += info.received
        sent += info.sent
    }
    
    func displayString(for rate: UInt64) -> String {
        let rateString: String
        
        switch rate {
        case let rate where rate >= UInt64(pow(1024.0, 3)):
            rateString = "\(String(format: "%.1f", Double(rate) / pow(1024.0, 3))) GB"
        case let rate where rate >= UInt64(pow(1024.0, 2)):
            rateString = "\(String(format: "%.1f", Double(rate) / pow(1024.0, 2))) MB"
        case let rate where rate >= 1024:
            rateString = "\(String(format: "%.1f", Double(rate) / 1024.0)) KB"
        default:
            rateString = "\(String(format: "%.1f", Double(rate))) B"
        }
        
        return rateString
    }
}
