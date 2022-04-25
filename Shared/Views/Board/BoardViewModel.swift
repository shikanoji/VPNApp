//
//  BoardViewModel.swift
//  SysVPN
//
//  Created by Phan Văn Đa on 17/12/2021.
//

import Foundation
import SwiftUI
import RxSwift
import TunnelKitManager

class BoardViewModel: ObservableObject {
    
    enum StateBoard {
        case notConnect
        case loading
        case connected
        
        var title: String {
            switch self {
            case .notConnect:
                return L10n.Board.navigationTitleNotConnect
            case .loading:
                return L10n.Board.connecting
            case .connected:
                return L10n.Board.connected
            }
        }
        
        var statusTitle: String {
            switch self {
            case .notConnect:
                return L10n.Board.unconnect
            case .loading:
                return L10n.Board.connecting
            case .connected:
                return L10n.Board.connected
            }
        }
        
        var statusColor: Color {
            switch self {
            case .notConnect, .loading:
                return AppColor.VPNUnconnect
            case .connected:
                return AppColor.VPNConnected
            }
        }
        
        var titleButton: String {
            switch self {
            case .notConnect:
                return L10n.Board.unconnect
            case .loading:
                return L10n.Board.connecting
            case .connected:
                return L10n.Board.connected
            }
        }
    }
    
    enum StateTab: Int {
        case location = 0
        case staticIP = 1
        case multiHop = 2
    }
    
    @Published var state: StateBoard = .notConnect
    @Published var ip = AppSetting.shared.ip
    @Published var nodes: [Node] = []
    @Published var errorMessage: String? = nil
    @Published var tab: StateTab = .location
    @Published var uploadSpeed: CGFloat = 0.0
    @Published var downloadSpeed: CGFloat = 0.0
    @Published var showCityNodes: Bool = false
    @Published var nodeConnected: Node? = nil
    
    @Published var locationData: [NodeGroup] = []
    
    @Published var staticIPData: [StaticServer] = []
    @Published var staticIPNodeSelecte: StaticServer? = nil
    
    @Published var mutilhopData: [(Node, Node)] = [(Node.country, Node.tokyo), (Node.country, Node.tokyo)]
    
    @Published var entryNodeListMutilhop: [Node] = Node.all
    @Published var exitNodeListMutilhop: [Node] = Node.all
    @Published var entryNodeSelectMutilhop: Node = Node.country
    @Published var exitNodeSelectMutilhop: Node = Node.tokyo
    @Published var mesh: Mesh = Mesh()
    
    @Published var configMapView: ConfigMapView = ConfigMapView()
    
    @Published var showAlert: Bool = false
    @Published var showProgressView: Bool = false
    
    var error: APIError?
    
    class ConfigMapView {
        var firstload = true
        var isConfig = false
        var progressingScale: CGFloat = 1
        var magScale: CGFloat = 1
        var totalScale: CGFloat = 1
        var location: CGPoint = CGPoint(
            x: Constant.Board.Map.widthScreen / 2,
            y: Constant.Board.Map.widthScreen)
    }
    
    let disposedBag = DisposeBag()
    
    init() {
        AppSetting.shared.updateDataMap ? getCountryList() : getDataFromLocal()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(VPNStatusDidChange(notification:)),
            name: VPNNotification.didChangeStatus,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(VPNDidFail(notification:)),
            name: VPNNotification.didFail,
            object: nil
        )

        Task {
            await OpenVPNManager.shared.vpn.prepare()
        }
    }
    
    func connectVPN() {
        if state == .notConnect {
            getRequestCertificate()
        } else {
            NetworkManager.shared.disconnect()
        }
    }
    
    @objc private func VPNStatusDidChange(notification: Notification) {
        
        print("VPNStatusDidChange: \(notification.vpnStatus)")
        
        switch notification.vpnStatus {
        case .connected:
            state = .connected
            
        case .disconnected:
            state = .notConnect
            
        case .disconnecting, .connecting:
            state = .loading
        }
    }

    @objc private func VPNDidFail(notification: Notification) {
        print("VPNStatusDidFail: \(notification.vpnError.localizedDescription)")
        state = .notConnect
    }
    
    func getCountryList() {
        APIManager.shared.getCountryList()
            .subscribe { [weak self] response in
                guard let `self` = self else {
                    return
                }
                
                if let result = response.result {
                    AppSetting.shared.saveDataMap(result)
                    self.configCountryList(result)
                } else {
                    let error = response.errors
                    if error.count > 0, let message = error[0] as? String {
                        self.error = APIError.identified(message: message)
                        self.showAlert = true
                    } else if !response.message.isEmpty {
                        self.error = APIError.identified(message: response.message)
                        self.showAlert = true
                    }
                }
            } onFailure: { error in
                self.error = APIError.identified(message: error.localizedDescription)
                self.showAlert = true
            }
            .disposed(by: disposedBag)
    }
    
    func getRequestCertificate() {
        self.showProgressView = true
        
        APIManager.shared.getRequestCertificate()
            .subscribe { [weak self] response in
                guard let `self` = self else {
                    return
                }
                
                self.showProgressView = false
                
                if let result = response.result {
                    NetworkManager.shared.requestCertificate = result
                    NetworkManager.shared.connect()
                } else {
                    let error = response.errors
                    if error.count > 0, let message = error[0] as? String {
                        self.error = APIError.identified(message: message)
                        self.showAlert = true
                    } else if !response.message.isEmpty {
                        self.error = APIError.identified(message: response.message)
                        self.showAlert = true
                    }
                }
            } onFailure: { error in
                self.error = APIError.identified(message: error.localizedDescription)
                self.showProgressView = false
                self.showAlert = true
            }
            .disposed(by: disposedBag)
    }
    
    func getAvaiableCity(_ cityNodes: [Node]) {
        if cityNodes.count > 0 {
            NetworkManager.shared.cityNode = cityNodes.first
        }
    }
    
    func getDataFromLocal() {
        if let dataMapLocal = AppSetting.shared.getDataMap() {
            configCountryList(dataMapLocal)
        }
    }
    
    func configCountryList(_ result: CountryListResultModel) {
        
        let countryNodes = result.availableCountries
        var cityNodes = [Node]()
        countryNodes.forEach { cityNodes.append(contentsOf: $0.cityNodeList) }
        self.mesh.configNode(nodes: countryNodes, cityNodes: cityNodes, clientCountryNode: result.clientCountryDetail)
        
        locationData = [
            NodeGroup(nodeList: result.recommendedCountries, type: .recommend),
            NodeGroup(nodeList: result.availableCountries, type: .all),
        ]
        
        staticIPData = result.staticServers
        getAvaiableCity(cityNodes)
    }
}
