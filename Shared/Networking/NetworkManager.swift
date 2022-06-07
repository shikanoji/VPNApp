//
//  NetworkManager.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 20/04/2022.
//

import Foundation
import UIKit

extension ItemCellType {
    var getConfigParam: String {
        switch self {
        case .openVPN, .recommend:
            return "ovpn"
        case .wireGuard:
            return "wg"
        default:
            return ""
        }
    }
}

class NetworkManager: ObservableObject {
    
    static var shared = NetworkManager()
    
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
    
    var selectConfig: ItemCellType {
        get {
            let type = AppSetting.shared.getConfigProtocol()
            AppSetting.shared.selectConfig = type.rawValue
            return type
        }
        set {
            AppSetting.shared.selectConfig = newValue.rawValue
        }
    }
    
    var requestCertificate: RequestCertificateModel?
    
    var obtainCertificate: ObtainCertificateModel?
    
    var selectNode: Node?
    
    var selectStaticServer: StaticServer?
    
    func connect() {
        switch selectConfig {
        case .openVPN, .recommend:
            OpenVPNManager.shared.connect()
        case .wireGuard:
            WireGuardManager.shared.connect()
        default:
            break
        }
    }
    
    func disconnect() {
        switch selectConfig {
        case .openVPN, .recommend:
            OpenVPNManager.shared.disconnect()
        case .wireGuard:
            WireGuardManager.shared.disconnect()
        default:
            break
        }
    }
}
