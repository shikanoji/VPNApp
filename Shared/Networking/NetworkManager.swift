//
//  NetworkManager.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 20/04/2022.
//

import Foundation
import UIKit
import RxSwift
import SwiftUI
import TunnelKitManager
import TunnelKitCore

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
        case .openVPNTCP:
            return "tcp"
        default:
            return "udp"
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
    
    func getNodeConnect() -> Node? {
        return ItemCell(type: AppSetting.shared.getAutoConnectProtocol()).type != .off ? AppSetting.shared.getAutoConnectNode() : selectNode
    }
}
