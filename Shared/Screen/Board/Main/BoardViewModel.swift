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
        case .connecting, .disconnecting:
            return L10n.Board.connecting
        case .disconnected:
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

enum StateTab: Int {
    case location = 0
    case staticIP = 1
    case multiHop = 2
    
    var title: String {
        switch self {
        case .location:
            return L10n.Board.locationTitleTab
        case .staticIP:
            return L10n.Board.staticIPTitleTab
        case .multiHop:
            return L10n.Board.multiHopTitleTab
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
    @Published var nodes: [Node] = []
    @Published var errorMessage: String? = nil
    
    @Published var showBoardList = false
    
    var isSwitchTab = false
    
    @Published var selectedTab: StateTab = .location {
        didSet {
            AppSetting.shared.saveCurrentTab(selectedTab)
        }
    }
    
    @Published var uploadSpeed: String = "0"
    @Published var downloadSpeed: String = "0"
      
    @Published var nodeSelectFromBoardList: Node? = nil {
        didSet {
            if let node = nodeSelectFromBoardList {
                showBoardList = false
                guard !NetworkManager.shared.networkConnectIsCurrentNetwork() else {
                    showAlertAutoConnectSetting = true
                    return
                }
                mesh?.removeSelectNode()
                AppSetting.shared.saveBoardTabWhenConnecting(.location)
                NetworkManager.shared.needReconnect = state == .connected
                NetworkManager.shared.nodeSelected = node
                NetworkManager.shared.connectOrDisconnectByUser = true
                NetworkManager.shared.ConnectOrDisconnectVPN()
            }
        }
    }
    
    @Published var locationData: [NodeGroup] = []
    
    @Published var staticIPData: [StaticServer] = []
    @Published var staticIPSelect: StaticServer? = nil {
        didSet {
            if let staticIP = staticIPSelect {
                showBoardList = false
                guard !NetworkManager.shared.networkConnectIsCurrentNetwork() else {
                    showAlertAutoConnectSetting = true
                    return
                }
                mesh?.removeSelectNode()
                AppSetting.shared.saveBoardTabWhenConnecting(.staticIP)
                NetworkManager.shared.needReconnect = state == .connected
                NetworkManager.shared.selectStaticServer = staticIP
                NetworkManager.shared.connectOrDisconnectByUser = true
                NetworkManager.shared.ConnectOrDisconnectVPN()
            }
        }
    }
    
    @Published var mutilhopList: [MultihopModel] = []
    @Published var multihopSelect: MultihopModel? = nil {
        didSet {
            if let multihop = multihopSelect {
                showBoardList = false
                guard !NetworkManager.shared.networkConnectIsCurrentNetwork() else {
                    showAlertAutoConnectSetting = true
                    return
                }
                mesh?.removeSelectNode()
                AppSetting.shared.saveBoardTabWhenConnecting(.multiHop)
                NetworkManager.shared.needReconnect = state == .connected
                NetworkManager.shared.selectMultihop = multihop
                NetworkManager.shared.connectOrDisconnectByUser = true
                NetworkManager.shared.ConnectOrDisconnectVPN()
            }
        }
    }
    
    var mesh: Mesh?
    var authentication: Authentication?
    
    @Published var showAlert: Bool = false {
        didSet {
            if showAlert {
                state = .disconnected
            }
        }
    }
    
    @Published var showAlertAutoConnectSetting: Bool = false
    @Published var showSessionTerminatedAlert: Bool = false
    @Published var showAlertSessionSetting: Bool = false
    @Published var shouldHideSession = true
    
    @Published var showProgressView: Bool = false
    
    @Published var showLogoView: Bool = true
    
    var error: APIError?
    
    let disposedBag = DisposeBag()
    
    var reconnectWhenLoseInternet = 0

    private var backgroundTaskId: UIBackgroundTaskIdentifier?
    
    var onlyDisconnectWithoutEndsession = false
    
    // MARK: INIT
    init() {
        selectedTab = AppSetting.shared.getCurrentTab()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(logoutNeedDisconnect),
            name: Constant.NameNotification.logoutNeedDisconnect,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(changeProtocolSetting),
            name: Constant.NameNotification.changeProtocolSetting,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(configDisconected),
            name: Constant.NameNotification.connectVPNError,
            object: nil
        )
        
        Task {
            await OpenVPNManager.shared.vpn.prepare()
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: .main) { _ in
            NetworkManager.shared.disconnect()
        }
        
        assignJailBreakCheckType(type: .readAndWriteFiles)
        AppSetting.shared.fetchListSession()
        
        NetworkManager.shared.stateUICallBack = {
            self.stateUI = $0
        }
        
        NetworkManager.shared.stateCallBack = {
            self.state = $0
            switch $0 {
            case .connected:
                self.configConnected()
            case .disconnected:
                self.configDisconected()
            default:
                break
            }
        }
        
        NetworkManager.shared.errorCallBack = {
            switch $0 {
            case .fullSession:
                self.showSessionTerminatedAlert = true
            case .sessionTerminate:
                self.showAlertSessionSetting = true
            case .apiError(let apiError):
                self.error = apiError
                self.showAlert = true
            case .autoConnecting:
                self.showAlertAutoConnectSetting = true
            case .authenNotPremium:
                self.authentication?.saveIsPremium(false)
            }
        }
        
        if NetworkManager.shared.state == .connected {
            configConnected()
        } else {
            configDisconnect()
        }
    }
    
    func configDataRemote() {
        getIpInfo {
            if !AppSetting.shared.isConnectedToVpn && AppSetting.shared.needLoadApiMap && Connectivity.sharedInstance.isReachable {
                self.getCountryList {
                    self.getMultihopList {
                    }
                }
            }
        }
    }
    
    func configDataLocal() {
        if AppSetting.shared.isConnectedToVpn || !AppSetting.shared.needLoadApiMap || !Connectivity.sharedInstance.isReachable {
            getDataFromLocal()
        }
    }
    
    @objc
    func changeProtocolSetting() {
        if state == .connected {
            NetworkManager.shared.needReconnect = true
            NetworkManager.shared.configDisconnect()
        }
    }
    
    // MARK: - HANDLE DATA MAP
    
    func getIpInfo(completion: @escaping () -> Void) {
        guard Connectivity.sharedInstance.isReachable else {
            completion()
            return
        }
        
        ServiceManager.shared.getAppSettings()
            .subscribe(onSuccess: { response in
                if let result = response.result {
                    AppSetting.shared.configAppSettings(result)
                }
                completion()
            }, onFailure: { error in
                completion()
            })
            .disposed(by: disposedBag)
    }
    
    func getCountryList(completion: @escaping () -> Void) {
        guard Connectivity.sharedInstance.isReachable else {
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
        guard Connectivity.sharedInstance.isReachable else {
            completion()
            return
        }
        
        ServiceManager.shared.getMutihopList()
            .subscribe { response in
                if let result = response.result {
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
        
        let countryNodes = result.availableCountries
        var cityNodes = [Node]()
        countryNodes.forEach { cityNodes.append(contentsOf: $0.cityNodeList) }
        
        locationData = [
            NodeGroup(nodeList: result.recommendedCountries, type: .recommend),
            NodeGroup(nodeList: result.availableCountries, type: .all),
        ]
        
        staticIPData = result.staticServers
        
        mesh?.configNode(countryNodes: countryNodes,
                         cityNodes: cityNodes,
                         staticNodes: staticIPData,
                         clientCountryNode: result.clientCountryDetail)
        
        getRecommendNode(result.recommendedCountries)
        getServerStats()
    }
    
    // MARK: - HANDLE CONFIG VPN
    
    @objc private func logoutNeedDisconnect() {
        if state == .connected {
            NetworkManager.shared.configDisconnect()
        }
    }
    
    @Published var shouldHideAutoConnect = true
    
    var isCheckingAutoConnect = false
    
    @objc private func autoConnectWithConfig() {
        if Connectivity.sharedInstance.isReachable {
            switch NetworkManager.shared.autoConnectType {
            case .always:
                AppSetting.shared.saveBoardTabWhenConnecting(.location)
                NetworkManager.shared.ConnectOrDisconnectVPN()
            case .onWifi:
                if Connectivity.sharedInstance.isReachableOnEthernetOrWiFi {
                    AppSetting.shared.saveBoardTabWhenConnecting(.location)
                    NetworkManager.shared.ConnectOrDisconnectVPN()
                }
            case .onMobile:
                if Connectivity.sharedInstance.isReachableOnCellular {
                    AppSetting.shared.saveBoardTabWhenConnecting(.location)
                    NetworkManager.shared.ConnectOrDisconnectVPN()
                }
            default:
                break
            }
        }
    }
    
    @objc
    func configDisconected() {
        ip = AppSetting.shared.ip
        flag = ""
        nameSelect = ""
        DispatchQueue.main.async {
            self.state = .disconnected
            self.stateUI = .disconnected
        }
        if onlyDisconnectWithoutEndsession {
            disconnectSession()
            onlyDisconnectWithoutEndsession = false
        }
    }
    
    func configDisconnect() {
        stateUI = .disconnected
        NetworkManager.shared.configDisconnect()
    }
    
    func getServerStats() {
        guard Connectivity.sharedInstance.isReachable else {
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
        guard Connectivity.sharedInstance.isReachable else {
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
    
    func configConnected() {
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
    
    func internetNotAvaiable() {
        error = APIError.noInternetConnect
        showProgressView = false
        showAlert = true
    }
    
    func disconnectSession() {
        ServiceManager.shared.disconnectSession(sessionId: AppSetting.shared.currentSessionId, terminal: false)
            .subscribe { [weak self] response in
                guard let self = self else {
                    return
                }
                
                self.showProgressView = false
                
                if response.success {
                  
                } else {

                }
            } onFailure: { error in
            }
            .disposed(by: disposedBag)
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
