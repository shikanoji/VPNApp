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
import NetworkExtension

private let appGroup = "group.sysvpn.client.ios"

#if DEBUG
private let tunnelIdentifier = "com.sysvpn.client.ios.dev.openvpn"
#else
private let tunnelIdentifier = "com.sysvpn.client.ios.openvpn"
#endif

class OpenVPNManager: ObservableObject {
    
    private var cfg: OpenVPN.ProviderConfiguration?
    let vpn = NetworkExtensionVPN()
    
    private let keychain = Keychain(group: appGroup)
    
    static var shared = OpenVPNManager()
    
    func connect() async {
        do {
            let string = (NetworkManager.shared.requestCertificate?.convertToString() ?? "") + getDNS()
            let config = try OpenVPN.ConfigurationParser.parsed(fromContents: string).configuration
            cfg = OpenVPN.ProviderConfiguration.init("openVPN", appGroup: appGroup, configuration: config)
            
            var extra = NetworkExtensionExtra()
            let rule = NEOnDemandRuleConnect()

            extra.onDemandRules = [rule]

            do {
                try await vpn.reconnect(
                    tunnelIdentifier,
                    configuration: cfg!,
                    extra: extra,
                    after: .seconds(2)
                )
            } catch {
                print(error)
                postError()
            }
        } catch {
            print(error)
            postError()
        }
    }
    
    func postError() {
        NetworkManager.shared.connectVPNError()
    }
    
    func getDataCount() -> DataCount? {
        return cfg?.dataCount
    }
    
    init() {
        Task {
            await vpn.prepare()
        }
    }
    
    func disconnect() async {
        await vpn.disconnect()
    }
    
    func getDNS() -> String {
        var stringData = ""
        
        guard let dnsCyberSec = NetworkManager.shared.requestCertificate?.dns,
              !dnsCyberSec.isEmpty, AppSetting.shared.selectCyberSec else {
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
