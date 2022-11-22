//
//  Connectivity.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 21/12/2021.
//

import Foundation
import Alamofire
import NetworkExtension

let checkingVPNSerialQueue = DispatchQueue(label: "sysvpn_checking_vpn_serial_queue", qos: .background)

class Connectivity: ObservableObject {
    static var sharedInstance = Connectivity()
    private let monitorWiFi = NWPathMonitor(requiredInterfaceType: .wifi)
    private let monitorCellular = NWPathMonitor(requiredInterfaceType: .cellular)

    var enableWifi = false {
        didSet {
            enableWifiCallBack?(enableWifi)
            enableNetworkCallBack?(enableWifi || enableCellular)
        }
    }
    var enableCellular = false {
        didSet {
            enableCellularCallBack?(enableCellular)
            enableNetworkCallBack?(enableWifi || enableCellular)
        }
    }

    var enableNetwork: Bool {
        return enableWifi || enableCellular
    }

    init() {
        detectNetwork()
    }

    var enableNetworkCallBack: ((Bool) -> Void)?
    var enableWifiCallBack: ((Bool) -> Void)?
    var enableCellularCallBack: ((Bool) -> Void)?

    func detectNetwork() {
        monitorWiFi.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                switch path.status {
                case .satisfied:
                    self.enableWifi = true
                default:
                    self.enableWifi = false
                }
            }
        }

        monitorCellular.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                switch path.status {
                case .satisfied:
                    self.enableCellular = true
                default:
                    self.enableCellular = false
                }
            }
        }

        monitorWiFi.start(queue: DispatchQueue(label: "monitorWiFi"))
        monitorCellular.start(queue: DispatchQueue(label: "monitorCellular"))
    }

    func checkIfVPNDropped() async {
        checkingVPNSerialQueue.async {
            if self.enableNetwork {
                Task {
                    await NetworkManager.shared.checkIfVPNDropped()
                }
            }
        }
    }
}
