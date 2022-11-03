//
//  PacketTunnelProvider.swift
//  WireGuard
//
//  Created by Da Phan Van on 15/04/2022.
//

import NetworkExtension
import TunnelKitWireGuardAppExtension

private let appGroup = "group.sysvpn.client.ios"

class PacketTunnelProvider: WireGuardTunnelProvider {
    let userDefaultsShared = UserDefaults(suiteName: appGroup)

    override func setTunnelNetworkSettings(_ tunnelNetworkSettings: NETunnelNetworkSettings?, completionHandler: ((Error?) -> Void)? = nil) {
        if let setting = tunnelNetworkSettings as? NEPacketTunnelNetworkSettings {
            if setting.ipv4Settings == nil {
                setting.ipv4Settings = NEIPv4Settings(addresses: [], subnetMasks: [])
            }

            var ips = [NEIPv4Route]()

            userDefaultsShared?.array(forKey: "server_ips")?.forEach { ip in
                if let ip = ip as? String {
                    ips.append(NEIPv4Route(destinationAddress: ip, subnetMask: "255.255.255.255"))
                }
            }

            setting.ipv4Settings?.excludedRoutes = ips
        }

        super.setTunnelNetworkSettings(tunnelNetworkSettings, completionHandler: completionHandler)
    }
}
