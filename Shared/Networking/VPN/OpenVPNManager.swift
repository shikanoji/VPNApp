//
//  OpenVPNManager.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 14/04/2022.
//

import Foundation
import TunnelKit
import TunnelKitManager
import TunnelKitOpenVPNCore
import TunnelKitOpenVPNManager
import TunnelKitCore

private let appGroup = "group.com.ilg.SysVPN"

private let tunnelIdentifier = "com.ilg.SysVPN.OpenVPN"

class OpenVPNManager: ObservableObject {
    
    private var cfg: OpenVPN.ProviderConfiguration?
    let vpn = NetworkExtensionVPN()
    
    private let keychain = Keychain(group: appGroup)
    
    static var shared = OpenVPNManager()
    
    func connect() {
        do {
            let string = (NetworkManager.shared.requestCertificate?.convertToString() ?? "") + getDNS()
            let config = try OpenVPN.ConfigurationParser.parsed(fromContents: string).configuration
            cfg = OpenVPN.ProviderConfiguration.init("openVPN", appGroup: appGroup, configuration: config)
            
            Task {
                try await vpn.reconnect(
                    tunnelIdentifier,
                    configuration: cfg!,
                    extra: nil,
                    after: .seconds(2)
                )
            }
        } catch {
            print(error)
        }
    }
    
    func getDataCount() -> DataCount? {
        return self.cfg?.dataCount
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
    
    func getDNS() -> String {
        var stringData = ""
        
        guard let dnsCyberSec = NetworkManager.shared.requestCertificate?.dns,
              dnsCyberSec.count > 0 else {
            if AppSetting.shared.primaryDNSValue != "" {
                stringData += "dhcp-option DNS " + AppSetting.shared.primaryDNSValue + "\r\n"
            }
            if AppSetting.shared.secondaryDNSValue != "" {
                stringData += "dhcp-option DNS " + AppSetting.shared.secondaryDNSValue + "\r\n"
            }
            
            return stringData
        }
        
        dnsCyberSec.forEach {
            stringData += "dhcp-option DNS " + $0 + "\r\n"
        }
       
        return stringData
    }
}
