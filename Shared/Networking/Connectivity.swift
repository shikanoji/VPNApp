//
//  Connectivity.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 21/12/2021.
//

import Foundation
import Alamofire
import NetworkExtension

class Connectivity: ObservableObject {
    static var sharedInstance = Connectivity()
    
    private let monitorWiFi = NWPathMonitor(requiredInterfaceType: .wifi)
    private let monitorCellular = NWPathMonitor(requiredInterfaceType: .cellular)
    
    var enableWifi = false
    var enableCellular = false
    
    var enableNetwork: Bool {
        return enableWifi || enableCellular
    }
    
    init() {
        detectNetwork()
    }
    
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
}
