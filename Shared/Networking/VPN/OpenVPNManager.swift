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
//import TunnelKitOpenVPNAppExtension
//import TunnelKitOpenVPNProtocol
import TunnelKitCore

private let appGroup = "group.com.ilg.SysVPN.dev.daz"

private let tunnelIdentifier = "com.ilg.SysVPN.dev.daz.OpenVPN"

class OpenVPNManager: ObservableObject {
    
    private var cfg: OpenVPN.ProviderConfiguration?
    let vpn = NetworkExtensionVPN()
    
    private let keychain = Keychain(group: appGroup)
    
    static var shared = OpenVPNManager()
    
    func connect() {
        do {
            let string = NetworkManager.shared.requestCertificate?.convertToString()
            let config = try OpenVPN.ConfigurationParser.parsed(fromContents: string!).configuration
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
}
