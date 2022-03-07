//
//  BoardViewModel.swift
//  SysVPN
//
//  Created by Phan Văn Đa on 17/12/2021.
//

import Foundation
import SwiftUI
import RxSwift

class BoardViewModel: ObservableObject {
    
    enum StateBoard {
        case notConnect
        case loading
        case connected
        
        var title: String {
            switch self {
            case .notConnect:
                return LocalizedStringKey.Board.titleNavigationNotConnect.localized
            case .loading:
                return LocalizedStringKey.Board.titleNavigationConnecting.localized
            case .connected:
                return LocalizedStringKey.Board.titleNavigationConnected.localized
            }
        }
        
        var statusTitle: String {
            switch self {
            case .notConnect:
                return LocalizedStringKey.Board.unConnect.localized
            case .loading:
                return LocalizedStringKey.Board.connecting.localized
            case .connected:
                return LocalizedStringKey.Board.connected.localized
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
                return LocalizedStringKey.Board.unConnect.localized
            case .loading:
                return LocalizedStringKey.Board.connecting.localized
            case .connected:
                return LocalizedStringKey.Board.connected.localized
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
    }
    
    func connectVPN() {
        self.state = .loading
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
                }
            } onFailure: { error in
                
            }
            .disposed(by: disposedBag)
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
    }
}
