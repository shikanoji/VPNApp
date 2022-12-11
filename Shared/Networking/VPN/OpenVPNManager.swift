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
    
    func connect(_ cert: RequestCertificateModel? = AppSetting.shared.requestCertificate) async {
        do {
            let string = (cert?.convertToString() ?? "") + getDNS()
            var config = try OpenVPN.ConfigurationParser.parsed(fromContents: string).configuration
            
            config.paramGetCertStr = AppSetting.shared.paramGetCert.json
            config.headerGetCert = AppSetting.shared.headerGetCert
            config.selectCyberSec = AppSetting.shared.selectCyberSec
            config.primaryDNSValue = AppSetting.shared.primaryDNSValue
            config.secondaryDNSValue = AppSetting.shared.secondaryDNSValue
            
            cfg = OpenVPN.ProviderConfiguration.init("OpenVPN", appGroup: appGroup, configuration: config)
            
            var extra = NetworkExtensionExtra()
            let rule = NEOnDemandRuleConnect()
            extra.onDemandRules = [rule]

            do {
                try await vpn.reconnect(
                    tunnelIdentifier,
                    configuration: cfg!,
                    extra: nil,
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
        NotificationCenter.default.post(name: Notification.Name("vpnDidFailConfig"), object: nil)
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
        
        guard let dnsCyberSec = AppSetting.shared.requestCertificate?.dns,
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

extension Dictionary {

    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }

    func printJson() {
        print(json)
    }
}
