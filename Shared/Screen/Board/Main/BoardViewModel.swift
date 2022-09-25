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
    
    var isSwitchTab = false
    
    @Published var tab: StateTab = .location {
        didSet {
            AppSetting.shared.saveCurrentTab(tab)
            mesh?.currentTab = tab
        }
    }
    
    @Published var uploadSpeed: String = "0"
    @Published var downloadSpeed: String = "0"
    
    @Published var showMap = true
      
    @Published var nodeConnected: Node? = nil {
        didSet {
            if let node = nodeConnected {
                mesh?.removeSelectNode()
                AppSetting.shared.saveCurrentTabConnected(.location)
                self.isSwitching = state == .connected
                NetworkManager.shared.selectNode = node
                self.connectOrDisconnectByUser = true
                self.ConnectOrDisconnectVPN()
                self.showMap.toggle()
            }
        }
    }
    
    @Published var locationData: [NodeGroup] = []
    
    @Published var staticIPData: [StaticServer] = []
    @Published var staticIPNodeSelecte: StaticServer? = nil {
        didSet {
            if let staticIP = staticIPNodeSelecte {
                mesh?.removeSelectNode()
                AppSetting.shared.saveCurrentTabConnected(.staticIP)
                self.isSwitching = state == .connected
                NetworkManager.shared.selectStaticServer = staticIP
                self.connectOrDisconnectByUser = true
                self.ConnectOrDisconnectVPN()
                self.showMap.toggle()
            }
        }
    }
    
    @Published var mutilhopList: [MultihopModel] = []
    @Published var multihopSelect: MultihopModel? = nil {
        didSet {
            if let multihop = multihopSelect {
                mesh?.removeSelectNode()
                AppSetting.shared.saveCurrentTabConnected(.multiHop)
                self.isSwitching = state == .connected
                NetworkManager.shared.selectMultihop = multihop
                self.connectOrDisconnectByUser = true
                self.ConnectOrDisconnectVPN()
                self.showMap.toggle()
            }
        }
    }
    
    var mesh: Mesh?
    
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
    
    var isSwitching = false
    
    var reconnectWhenLoseInternet = 0

    private var backgroundTaskId: UIBackgroundTaskIdentifier?
    
    var onlyDisconnectWithoutEndsession = false
    
    // MARK: INIT
    init() {
        beginBackgroundTask()
        tab = AppSetting.shared.getCurrentTab()
        
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

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(checkAutoconnect),
            name: Constant.NameNotification.checkAutoconnect,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(disconnectCurrentSession),
            name: Constant.NameNotification.disconnectCurrentSession,
            object: nil
        )
        
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
        
        Task {
            await OpenVPNManager.shared.vpn.prepare()
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: .main) { _ in
            NetworkManager.shared.disconnect()
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(notiShowMap),
            name: Constant.NameNotification.showMap,
            object: nil
        )
        
        checkInternetRealTime()
        
        assignJailBreakCheckType(type: .readAndWriteFiles)
        AppSetting.shared.fetchListSession()
        
        getIpInfo {
            if AppSetting.shared.isConnectedToVpn || !AppSetting.shared.needLoadApiMap {
                self.getDataFromLocal()
            } else {
                self.getCountryList {
                    self.getMultihopList {
                    }
                }
            }
        }
        
        if AppSetting.shared.isConnectedToVpn {
            configConnected()
        }
    }
    
    ///Register background task
    private func beginBackgroundTask() {
        backgroundTaskId = UIApplication.shared.beginBackgroundTask(withName: "sysvpn.client.ios.vpnkeeper") { [weak self] in
            self?.backgroundTaskExpired()
        }
    }

    private func endBackgroundTask() {
        guard let backgroundTaskId = backgroundTaskId else { return }
        UIApplication.shared.endBackgroundTask(backgroundTaskId)
        self.backgroundTaskId = nil
    }

    private func backgroundTaskExpired() {
        // End BG task to make sure app not be killed
        endBackgroundTask()
    }
        
    @objc
    func changeProtocolSetting() {
        if state == .connected {
            isSwitching = true
            configDisconnect()
        }
    }
    
    @objc
    func notiShowMap() {
        showMap.toggle()
    }
    
    // MARK: - HANDLE DATA MAP
    
    func getIpInfo(completion: @escaping () -> Void) {
        guard Connectivity.sharedInstance.isReachable else {
            completion()
            return
        }
        
        ServiceManager.shared.getAppSettings()
            .subscribe(onSuccess: { response in
                if let result = response.result{
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
                if let result = response.result, result.availableCountries.count > 0 {
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
                    if result.count > 0 {
                        if let selectLocal = NetworkManager.shared.selectMultihop {
                            if self.mutilhopList.filter({ selectLocal.id == $0.id }).count == 0 {
                                NetworkManager.shared.selectMultihop = result.first
                            }
                        } else {
                            NetworkManager.shared.selectMultihop = result.first
                        }
                    }
                }
                completion()
            } onFailure: { error in
                completion()
            }
            .disposed(by: disposedBag)
    }
    
    func getRecommendNode(_ nodeList: [Node]) {
        if nodeList.count > 0 {
            if let _ = NetworkManager.shared.selectNode {
                
            } else {
                NetworkManager.shared.selectNode = nodeList.first
            }
            
            AppSetting.shared.saveRecommendedCountries(nodeList)
        }
    }
    
    func getDataFromLocal() {
        if let dataMapLocal = AppSetting.shared.getDataMap() {
            configCountryList(dataMapLocal)
        } else {
            self.getCountryList {
                self.getMultihopList {
                }
            }
        }
        
        if let multihopListLocal = AppSetting.shared.getMutilhopList() {
            mutilhopList = multihopListLocal
            if mutilhopList.count > 0 {
                NetworkManager.shared.selectMultihop = mutilhopList.first
            }
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
        
        if staticIPData.count > 0 {
            if let staticLocal = NetworkManager.shared.selectStaticServer {
                if self.staticIPData.filter({ staticLocal.id == $0.id }).count == 0 {
                    NetworkManager.shared.selectStaticServer = staticIPData.first
                }
            } else {
                NetworkManager.shared.selectStaticServer = staticIPData.first
            }
        }
        
        self.mesh?.configNode(countryNodes: countryNodes,
                              cityNodes: cityNodes,
                              staticNodes: staticIPData,
                              clientCountryNode: result.clientCountryDetail)
        
        getRecommendNode(result.recommendedCountries)
        
        getServerStats()
    }
    
    // MARK: - HANDLE CONFIG VPN
    
    @objc private func logoutNeedDisconnect() {
        if state == .connected {
            configDisconnect()
        }
    }
    
    @objc private func disconnectCurrentSession() {
        onlyDisconnectWithoutEndsession = true
        configDisconnect()
    }
    
    @Published var shouldHideAutoConnect = true
    
    var isCheckingAutoConnect = false
    
    @objc private func autoConnectWithConfig() {
        if Connectivity.sharedInstance.isReachable {
            switch self.autoConnectType {
            case .always:
                tab = .location
                AppSetting.shared.saveCurrentTabConnected(.location)
                ConnectOrDisconnectVPN()
            case .onWifi:
                if Connectivity.sharedInstance.isReachableOnEthernetOrWiFi {
                    tab = .location
                    AppSetting.shared.saveCurrentTabConnected(.location)
                    ConnectOrDisconnectVPN()
                }
            case .onMobile:
                if Connectivity.sharedInstance.isReachableOnCellular {
                    tab = .location
                    AppSetting.shared.saveCurrentTabConnected(.location)
                    ConnectOrDisconnectVPN()
                }
            default:
                break
            }
        }
    }
    
    var startConnectOrDisconnect = false
    
    func ConnectOrDisconnectVPN() {
        startConnectOrDisconnect = true
        switch autoConnectType {
        case .off:
                switch state {
                case .disconnected:
                    configStartConnectVPN()
                case .connecting, .disconnecting:
                    break
                default:
                    configDisconnect()
                }
        default:
            guard !AppSetting.shared.temporaryDisableAutoConnect else {
                configDisconnect()
                return
            }
            if connectOrDisconnectByUser, state == .connected {
                showAlertAutoConnectSetting = true
            } else {
                switch state {
                case .disconnected:
                    configStartConnectVPN()
                default:
                    break
                }
            }
        }
    }
    
    func configDisconected() {
        ip = AppSetting.shared.ip
        flag = ""
        nameSelect = ""
        DispatchQueue.main.async {
            self.stopSpeedTimer()
            self.state = .disconnected
            self.stateUI = .disconnected
        }
        if onlyDisconnectWithoutEndsession {
            disconnectSession()
            onlyDisconnectWithoutEndsession = false
        }
        if isSwitching {
            isSwitching = false
            configStartConnectVPN()
        }
        
        AppSetting.shared.lineNetwork = 0
        if connectOrDisconnectByUser {
            AppSetting.shared.currentSessionId = ""
        }
        
        AppSetting.shared.saveTimeConnectedVPN = nil
    }
    
    func configDisconnect() {
        connectOrDisconnectByUser = true
        numberReconnect = 0
        stateUI = .disconnected
        NetworkManager.shared.disconnect()
    }
    
    func configStartConnectVPN() {
        if state == .disconnected {
            numberReconnect = 0
            stateUI = .connecting
            startConnectVPN()
        }
    }
    
    func startConnectVPN() {
        getRequestCertificate(asNewConnection: AppSetting.shared.needToStartNewSession) {
            if $0 {
                NetworkManager.shared.connect()
            } else {
                if self.isSwitching {
                    self.isSwitching = false
                }
                self.configDisconnect()
            }
        }
    }
    
    let maximumReconnect = 3
    var numberReconnect = 0
    
    var isEnableReconect: Bool {
        get { numberReconnect < maximumReconnect }
    }
    
    var connectOrDisconnectByUser = false
    
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
        if AppSetting.shared.saveTimeConnectedVPN == nil {
            AppSetting.shared.saveTimeConnectedVPN = Date()
        }
        numberReconnect = 0
        state = .connected
        stateUI = .connected
        connectOrDisconnectByUser = false
        stopSpeedTimer()
        
        getStatsByServer()
        
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
        
        if autoConnectType == .off {
            switch AppSetting.shared.getCurrentTabConnected() {
            case .location:
                if let nodeSelect = NetworkManager.shared.selectNode {
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
            if let nodeSelect = NetworkManager.shared.getNodeConnect() {
                flag = nodeSelect.flag
                nameSelect = nodeSelect.isCity ? nodeSelect.name : nodeSelect.countryName
            }
        }
        getSpeedRealTime()
    }
    
    @objc private func VPNStatusDidChange(notification: Notification) {
       
        print("VPNStatusDidChange: \(notification.vpnStatus)")
        
        guard state != notification.vpnStatus else {
            return
        }
        
        state = notification.vpnStatus
        
        if stateUI != state {
            stateUI = state
        }
        
        switch stateUI {
        case .connected:
            configConnected()
            if autoConnectType == .off {
                if reconnectWhenLoseInternet <= 0 {
                    reconnectWhenLoseInternet = 1
                } else if reconnectWhenLoseInternet == 2 {
                    reconnectWhenLoseInternet = 1
                }
            }
        case .disconnected:
            if autoConnectType == .off {
                if !Connectivity.sharedInstance.isReachable {
                    if reconnectWhenLoseInternet == 1 {
                        reconnectWhenLoseInternet = 2
                    }
                } else {
                    reconnectWhenLoseInternet = 0
                }
            }
            
            if !startConnectOrDisconnect {
                if AppSetting.shared.isConnectedToVpn {
                    configConnected()
                    return
                }
            }
            
            if isEnableReconect,
               !connectOrDisconnectByUser {
                startConnectVPN()
            } else {
                configDisconected()
            }
        default:
            break
        }
    }
    
    @MainActor @objc private func VPNDidFail(notification: Notification) {
        print("VPNStatusDidFail: \(notification.vpnError.localizedDescription)")
        stopSpeedTimer()
        guard notification.vpnError.localizedDescription != "permission denied" else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.configDisconected()
            })
            return
        }
        configDisconected()
        if isEnableReconect, !connectOrDisconnectByUser {
            startConnectVPN()
        }
    }
    
    var checkInternetTimer: DispatchSourceTimer?
    
    var autoConnectType = ItemCell(type: AppSetting.shared.getAutoConnectProtocol()).type
    
    @objc func checkAutoconnect() {
        autoConnectType = ItemCell(type: AppSetting.shared.getAutoConnectProtocol()).type
    }
    
    @objc func checkInternetRealTime() {
        
        guard !isCheckingAutoConnect else {
            return
        }
        
        isCheckingAutoConnect = true
        
        stopAutoconnectTimer()
        let queue = DispatchQueue.main
        checkInternetTimer = DispatchSource.makeTimerSource(queue: queue)
        checkInternetTimer!.schedule(deadline: .now(), repeating: .seconds(3))
        checkInternetTimer!.setEventHandler { [weak self] in
            switch self?.autoConnectType {
            case .always, .onWifi, .onMobile:
                if self?.stateUI == .disconnected && !AppSetting.shared.isConnectedToVpn {
                    self?.autoConnectWithConfig()
                }
            case .off:
                if self?.reconnectWhenLoseInternet == 2 && Connectivity.sharedInstance.isReachable && self?.stateUI == .disconnected && !(self?.connectOrDisconnectByUser ?? false) {
                    self?.ConnectOrDisconnectVPN()
                }
            default:
                break
            }
        }
        checkInternetTimer!.resume()
    }
    
    var speedTimer: DispatchSourceTimer?

    var lastSent: UInt = UInt(0)
    var lastReceived: UInt = UInt(0)
    
    func getSpeedRealTime() {
        lastSent = UInt(0)
        lastReceived = UInt(0)
        let queue = DispatchQueue.main
        speedTimer = DispatchSource.makeTimerSource(queue: queue)
        speedTimer!.schedule(deadline: .now(), repeating: .seconds(1))
        speedTimer!.setEventHandler { [weak self] in
            if [.openVPNTCP, .openVPNUDP].contains(NetworkManager.shared.getValueConfigProtocol),
               let dataCount = OpenVPNManager.shared.getDataCount() {
                let uploadSpeed = abs(Int32(dataCount.sent - (self?.lastSent ?? 0)))
                let downSpeed = abs(Int32(dataCount.received - (self?.lastReceived ?? 0)))
                self?.uploadSpeed = UInt(uploadSpeed).descriptionAsDataUnit
                self?.downloadSpeed = UInt(downSpeed).descriptionAsDataUnit
                self?.lastSent = dataCount.sent
                self?.lastReceived = dataCount.received
            }
        }
        speedTimer!.resume()
    }
        
    func stopSpeedTimer() {
        speedTimer = nil
    }
    
    func stopAutoconnectTimer() {
        checkInternetTimer = nil
    }
    
    deinit {
        stopSpeedTimer()
        stopAutoconnectTimer()
        endBackgroundTask()
    }
    
    func internetNotAvaiable() {
        self.error = APIError.noInternet
        self.showProgressView = false
        self.showAlert = true
    }
    
    func getRequestCertificate(asNewConnection: Bool = false, completion: @escaping (Bool) -> Void) {
        guard isEnableReconect else {
            completion(false)
            return
        }
        
        numberReconnect += 1
        
        guard Connectivity.sharedInstance.isReachable else {
            internetNotAvaiable()
            configDisconected()
            return
        }
        
        if let node = mesh?.selectedNode {
            AppSetting.shared.saveCurrentTabConnected(.location)
            NetworkManager.shared.selectNode = node
        }
        
        showMap.toggle()
        
        ServiceManager.shared.getRequestCertificate(asNewConnection: asNewConnection)
            .subscribe { [weak self] response in
                guard let `self` = self else {
                    return
                }
                self.showProgressView = false
                if let result = response.result {
                    switch NetworkManager.shared.getValueConfigProtocol {
                    case .openVPNTCP, .openVPNUDP:
                        if let cer = result.getRequestCer {
                            if !cer.exceedLimit {
                                if cer.allowReconnect {
                                    NetworkManager.shared.requestCertificate = cer
                                    AppSetting.shared.needToStartNewSession = false
                                    AppSetting.shared.currentSessionId = NetworkManager.shared.requestCertificate?.sessionId ?? ""
                                    completion(true)
                                    return
                                } else {
                                    AppSetting.shared.temporaryDisableAutoConnect = true
                                    AppSetting.shared.needToStartNewSession = true
                                    self.showSessionTerminatedAlert = true
                                    self.stateUI = .disconnected
                                    completion(false)
                                    return
                                }
                            } else {
                                completion(false)
                                self.showAlertSessionSetting = true
                                return
                            }
                        } else if self.isEnableReconect {
                            self.getRequestCertificate(asNewConnection: AppSetting.shared.needToStartNewSession) {
                                completion($0)
                                return
                            }
                        } else {
                            self.stateUI = .disconnected
                            completion(false)
                            return
                        }
                    case .wireGuard:
                        if let cer = result.getObtainCer {
                            if !cer.exceedLimit {
                                if cer.allowReconnect {
                                    AppSetting.shared.needToStartNewSession = false
                                    NetworkManager.shared.obtainCertificate = cer
                                    AppSetting.shared.currentSessionId = cer.sessionId ?? ""
                                    completion(true)
                                    return
                                } else {
                                    AppSetting.shared.temporaryDisableAutoConnect = true
                                    AppSetting.shared.needToStartNewSession = true
                                    self.showSessionTerminatedAlert = true
                                    self.stateUI = .disconnected
                                    completion(false)
                                    return
                                }
                            } else {
                                completion(false)
                                self.showAlertSessionSetting = true
                                return
                            }
                        } else if self.isEnableReconect {
                            self.getRequestCertificate(asNewConnection: AppSetting.shared.needToStartNewSession) {
                                completion($0)
                                return
                            }
                        } else {
                            self.stateUI = .disconnected
                            completion(false)
                            return
                        }
                    default:
                        self.stateUI = .disconnected
                        completion(false)
                        return
                    }
                } else {
                    if self.isEnableReconect {
                        self.getRequestCertificate(asNewConnection: AppSetting.shared.needToStartNewSession) {
                            completion($0)
                            return
                        }
                    } else {
                        self.configDisconnect()
                        let error = response.errors
                        if error.count > 0, let message = error[0] as? String {
                            self.error = APIError.identified(message: message)
                            self.showAlert = true
                        } else if !response.message.isEmpty {
                            self.error = APIError.identified(message: response.message)
                            self.showAlert = true
                        }
                        completion(false)
                        return
                    }
                }
            } onFailure: { error in
                if self.isEnableReconect {
                    self.getRequestCertificate(asNewConnection: AppSetting.shared.needToStartNewSession) {
                        completion($0)
                        return
                    }
                } else {
                    if let errorConfig = error as? APIError {
                        self.error = errorConfig
                    }
                    self.showProgressView = false
                    self.showAlert = true
                    completion(false)
                    return
                }
            }
            .disposed(by: disposedBag)
    }
    
    func disconnectSession() {
        ServiceManager.shared.disconnectSession(sessionId: AppSetting.shared.currentSessionId, terminal: false)
            .subscribe { [weak self] response in
                guard let `self` = self else {
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
        if value{
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
            // exit(-1)
        }
    }
}
