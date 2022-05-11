//
//  NetworkManager.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 20/04/2022.
//

import Foundation
import UIKit

class NetworkManager: ObservableObject {
    
    static var shared = NetworkManager()
    
    enum ConfigVPN {
        case openVPN
        case wireguard
        
        var description: String {
            switch self {
            case .openVPN:
                return "ovpn"
            case .wireguard:
                return "wg"
            }
        }
    }
    
    enum ProtocolVPN {
        case udp
        case tcp
        
        var description: String {
            switch self {
            case .udp:
                return "udp"
            case .tcp:
                return "tcp"
            }
        }
    }
    
    var protocolVPN: ProtocolVPN = .tcp
    
    var selectConfig: ConfigVPN = .openVPN
    
    var requestCertificate: RequestCertificateModel?
    
    var obtainCertificate: ObtainCertificateModel?
    
    var selectNode: Node?
    
    var selectStaticServer: StaticServer?
    
    func connect() {
        switch selectConfig {
        case .openVPN:
            OpenVPNManager.shared.connect()
        case .wireguard:
            WireGuardManager.shared.connect()
        }
    }
    
    func disconnect() {
        switch selectConfig {
        case .openVPN:
            OpenVPNManager.shared.disconnect()
        case .wireguard:
            WireGuardManager.shared.disconnect()
        }
    }
}
