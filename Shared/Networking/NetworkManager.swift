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
        case .openVPNTCP, .recommend, .openVPNUDP:
            return "ovpn"
        case .wireGuard:
            return "wg"
        default:
            return ""
        }
    }
    
    var getProtocolVPN: String {
        switch self {
        case .openVPNTCP, .recommend:
            return "tcp"
        case .openVPNUDP:
            return "udp"
        default:
            return ""
        }
    }
}

class NetworkManager: ObservableObject {
    
    static var shared = NetworkManager()
    
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
    
    var selectMultihop: MultihopModel?
    
    func connect() {
        switch selectConfig {
        case .openVPNTCP, .recommend, .openVPNUDP:
            OpenVPNManager.shared.connect()
        case .wireGuard:
            WireGuardManager.shared.connect()
        default:
            break
        }
    }
    
    func disconnect() {
        switch selectConfig {
        case .openVPNTCP, .recommend, .openVPNUDP:
            OpenVPNManager.shared.disconnect()
        case .wireGuard:
            WireGuardManager.shared.disconnect()
        default:
            break
        }
    }
}