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
import TunnelKitCore
import UIKit

extension VPNStatus {
    var title: String {
        switch self {
        case .connected:
            return L10n.Board.connected
        case .connecting:
            return L10n.Board.connecting
        case .disconnected, .disconnecting:
            return L10n.Board.navigationTitleNotConnect
        }
    }
    
    var statusTitle: String {
        switch self {
        case .disconnected:
            return L10n.Board.unconnect
        case .connecting, .disconnecting:
            return L10n.Board.connecting
        case .connected:
            return L10n.Board.navigationTitleConnected
        }
    }
    
    var statusColor: Color {
        switch self {
        case .disconnected, .connecting, .disconnecting:
            return AppColor.VPNUnconnect
        case .connected:
            return AppColor.VPNConnected
        }
    }
    
    var titleButton: String {
        switch self {
        case .disconnected:
            return L10n.Board.unconnect
        case .connecting, .disconnecting:
            return L10n.Board.connecting
        case .connected:
            return L10n.Board.connected
        }
    }
}

class BoardViewModel: ObservableObject {
    
    // MARK: Variable
    @Published var showAutoConnect: Bool = false
    @Published var showProtocolConnect: Bool = false
    @Published var showDNSSetting: Bool = false
    @Published var stateUI: VPNStatus = .disconnected
    @Published var state: VPNStatus = .disconnected
    @Published var ip = AppSetting.shared.ip
    @Published var flag = ""
    @Published var nameSelect = ""
    
    @Published var showBoardListIphone = false
    @Published var showBoardListIpad = false
    @Published var selectedTab: StateTab = .location {
        didSet {
            AppSetting.shared.saveCurrentTab(selectedTab)
        }
    }

    @Published var nodeSelectFromBoardList: Node? = nil {
        didSet {
            if let node = nodeSelectFromBoardList {
                configShowBoardList(false)
                guard !NetworkManager.shared.networkConnectIsCurrentNetwork() else {
                    showAlertAutoConnectSetting = true
                    return
                }
                mesh?.removeSelectNode()
                AppSetting.shared.saveBoardTabWhenConnecting(.location)
                AppSetting.shared.shouldReconnectVPNIfDropped = state == .connected
                NetworkManager.shared.nodeSelected = node
                NetworkManager.shared.connectOrDisconnectByUser = true
                Task {
                    await NetworkManager.shared.ConnectOrDisconnectVPN()
                }
            }
        }
    }
    
    @Published var locationData: [NodeGroup] = []
    
    @Published var staticIPData: [StaticServer] = []
    @Published var staticIPSelect: StaticServer? = nil {
        didSet {
            if let staticIP = staticIPSelect {
                configShowBoardList(false)
                guard !NetworkManager.shared.networkConnectIsCurrentNetwork() else {
                    showAlertAutoConnectSetting = true
                    return
                }
                mesh?.removeSelectNode()
                AppSetting.shared.saveBoardTabWhenConnecting(.staticIP)
                AppSetting.shared.shouldReconnectVPNIfDropped = state == .connected
                NetworkManager.shared.selectStaticServer = staticIP
                NetworkManager.shared.connectOrDisconnectByUser = true
                Task {
                    await NetworkManager.shared.ConnectOrDisconnectVPN()
                }
            }
        }
    }
    
    @Published var mutilhopList: [MultihopModel] = []
    @Published var multihopSelect: MultihopModel? = nil {
        didSet {
            if let multihop = multihopSelect {
                configShowBoardList(false)
                guard !NetworkManager.shared.networkConnectIsCurrentNetwork() else {
                    showAlertAutoConnectSetting = true
                    return
                }
                mesh?.removeSelectNode()
                AppSetting.shared.saveBoardTabWhenConnecting(.multiHop)
                AppSetting.shared.shouldReconnectVPNIfDropped = state == .connected
                NetworkManager.shared.selectMultihop = multihop
                NetworkManager.shared.connectOrDisconnectByUser = true
                Task {
                    await NetworkManager.shared.ConnectOrDisconnectVPN()
                }
            }
        }
    }
    
    var mesh: Mesh?
    var authentication: Authentication?
    
    @Published var showAlert: Bool = false {
        didSet {
            if showAlert {
                DispatchQueue.main.async {
                    self.state = .disconnected
                }
            }
        }
    }
    
    @Published var showAlertAutoConnectSetting: Bool = false
    @Published var showSessionTerminatedAlert: Bool = false
    @Published var showAlertSessionSetting: Bool = false
    @Published var shouldHideSession = true
    
    var error: AppAPIError?
    let disposedBag = DisposeBag()
    
    // MARK: INIT
    init() {
        selectedTab = AppSetting.shared.getCurrentTab()
        
        assignJailBreakCheckType(type: .readAndWriteFiles)
        AppSetting.shared.fetchListSession()

        NetworkManager.shared.stateUICallBack = { status -> () in
            DispatchQueue.main.async { [weak self] in
                self?.stateUI = status
            }
        }

        DispatchQueue.main.async {
            NetworkManager.shared.stateCallBack = { state in
                DispatchQueue.main.async {
                    self.state = state
                    switch self.state {
                    case .connected:
                        self.configConnected()
                    case .disconnected:
                        self.configDisconnected()
                    default:
                        break
                    }
                }
            }
        }

        NetworkManager.shared.errorCallBack = {
            switch $0 {
            case .fullSession:
                self.showAlertSessionSetting = true
            case .sessionTerminate:
                self.showSessionTerminatedAlert = true
                AppSetting.shared.selectAutoConnect = ItemCellType.off.rawValue
            case .apiError(let apiError):
                self.error = apiError
                DispatchQueue.main.async {
                    self.showAlert = true
                }
            case .autoConnecting:
                self.showAlertAutoConnectSetting = true
            case .authenNotPremium:
                self.authentication?.saveIsPremium(false)
            }
        }
        
        DispatchQueue.main.async {
            if NetworkManager.shared.state == .connected {
                self.configConnected()
            } else {
                self.configDisconnected()
            }
        }
    }
    
    func configShowBoardList(_ config: Bool) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            showBoardListIpad = config
        } else {
            showBoardListIphone = config
        }
    }
    
    func configDataRemote() {
        getIpInfo {
            if !AppSetting.shared.isConnectedToVpn {
                self.getCountryList {
                    self.getMultihopList {
                    }
                }
            }
        }
    }
    
    func configDataLocal() {
        if AppSetting.shared.isConnectedToVpn {
            getDataFromLocal()
        }
    }
    
    // MARK: - HANDLE DATA MAP
    
    func getIpInfo(completion: @escaping () -> Void) {
        guard Connectivity.sharedInstance.enableNetwork else {
            completion()
            return
        }
        
        ServiceManager.shared.getAppSettings()
            .subscribe(onSuccess: { response in
                if let result = response.result {
                    AppSetting.shared.configAppSettings(result)
                    print("getIpInfo \(result)")
                }
                completion()
            }, onFailure: { error in
                completion()
            })
            .disposed(by: disposedBag)
    }
    
    func getCountryList(completion: @escaping () -> Void) {
        guard (Connectivity.sharedInstance.enableNetwork) else {
            completion()
            return
        }
        
        ServiceManager.shared.getCountryList()
            .subscribe { response in
                if let result = response.result, !result.availableCountries.isEmpty {
                    AppSetting.shared.saveDataMap(result)
                    self.configCountryList(result)
                }
                completion()
            } onFailure: { _ in
                completion()
            }
            .disposed(by: disposedBag)
    }
    
    func getMultihopList(completion: @escaping () -> Void) {
        guard (Connectivity.sharedInstance.enableNetwork) else {
            completion()
            return
        }
        
        ServiceManager.shared.getMutihopList()
            .subscribe { response in
                if let result = response.result, !result.isEmpty {
                    AppSetting.shared.saveMutilhopList(result)
                    self.mutilhopList = result
                }
                completion()
            } onFailure: { error in
                completion()
            }
            .disposed(by: disposedBag)
    }
    
    func getRecommendNode(_ nodeList: [Node]) {
        if !nodeList.isEmpty {
            if let _ = NetworkManager.shared.nodeSelected {
                
            } else {
                NetworkManager.shared.nodeSelected = nodeList.first
            }
            
            AppSetting.shared.saveRecommendedCountries(nodeList)
        }
    }
    
    func getDataFromLocal() {
        if let dataMapLocal = AppSetting.shared.getDataMap() {
            configCountryList(dataMapLocal)
        } else {
            getCountryList {
                self.getMultihopList {
                }
            }
        }
        
        if let multihopListLocal = AppSetting.shared.getMutilhopList() {
            mutilhopList = multihopListLocal
        }
    }
    
    func configCountryList(_ result: CountryListResultModel) {
        DispatchQueue.main.async {
            let countryNodes = result.availableCountries
            var cityNodes = [Node]()
            countryNodes.forEach { cityNodes.append(contentsOf: $0.cityNodeList) }

            self.locationData = [
                NodeGroup(nodeList: result.recommendedCountries, type: .recommend),
                NodeGroup(nodeList: result.availableCountries, type: .all),
            ]

            self.staticIPData = result.staticServers

            self.mesh?.configNode(countryNodes: countryNodes,
                                  cityNodes: cityNodes,
                                  staticNodes: self.staticIPData,
                                  clientCountryNode: result.clientCountryDetail)

            self.getRecommendNode(result.recommendedCountries)
            self.getServerStats()
        }
    }
    
    // MARK: - HANDLE CONFIG VPN
    func configDisconnected() {
        ip = AppSetting.shared.ip
        flag = ""
        nameSelect = ""
        state = .disconnected
        stateUI = .disconnected
    }
    
    func getServerStats() {
        guard Connectivity.sharedInstance.enableNetwork else {
            return
        }
        
        ServiceManager.shared.getServerStats()
            .subscribe { response in
                if let result = response.result?.rows {
                    let updateStaticNodesMesh = self.mesh?.staticNodes.map { staticNode -> StaticServer in
                        var updateNode = staticNode
                        
                        if let statsNode = result.filter({
                            $0.serverId == staticNode.serverId
                        }).first {
                            updateNode.score = statsNode.score
                        }
                        return updateNode
                    }
                    
                    self.mesh?.updateStaticNodes(updateStaticNodesMesh ?? [])
                    self.staticIPData = updateStaticNodesMesh ?? []
                }
            } onFailure: { _ in

            }
            .disposed(by: disposedBag)
    }
    
    func getStatsByServer() {
        guard Connectivity.sharedInstance.enableNetwork else {
            return
        }
        
        ServiceManager.shared.getStatsByServer()
            .subscribe { response in
                if let result = response.result {
                    AppSetting.shared.lineNetwork = result.score
                }
            } onFailure: { _ in
                AppSetting.shared.lineNetwork = 0
            }
            .disposed(by: disposedBag)
    }
    
    @MainActor func configConnected() {
        state = .connected
        stateUI = .connected
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.getStatsByServer()
            AppSetting.shared.fetchListSession()
        }
        
        switch NetworkManager.shared.getValueConfigProtocol {
        case .openVPNTCP, .openVPNUDP:
            if let iPVPN = NetworkManager.shared.requestCertificate?.server?.ipAddress {
                ip = iPVPN
            }
            
        case .wireGuard:
            if let iPWireguard = NetworkManager.shared.obtainCertificate?.server?.ipAddress {
                ip = iPWireguard
            }
            
        default:
            break
        }
        
        if NetworkManager.shared.autoConnectType == .off {
            switch AppSetting.shared.getBoardTabWhenConnecting() {
            case .location:
                if let nodeSelect = NetworkManager.shared.nodeConnecting {
                    flag = nodeSelect.flag
                    nameSelect = nodeSelect.isCity ? nodeSelect.name : nodeSelect.countryName
                }
                
            case .staticIP:
                if let staticServer = NetworkManager.shared.selectStaticServer {
                    flag = staticServer.flag
                    nameSelect = staticServer.countryName
                }
            case .multiHop:
                if let multihop = NetworkManager.shared.selectMultihop,
                   let country = multihop.exit?.country {
                    flag = country.flag
                    nameSelect = country.name
                }
            }
        } else {
            if let nodeSelect = NetworkManager.shared.nodeConnecting {
                flag = nodeSelect.flag
                nameSelect = nodeSelect.isCity ? nodeSelect.name : nodeSelect.countryName
            }
        }
    }
}

extension BoardViewModel: Check_Method_Of_JailBreak {
    func sendTheStatusOfJailBreak(value: Bool) {
        AppSetting.shared.wasJailBreak = value ? 1 : 0
        if value {
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
            // exit(-1)
        }
    }
}
