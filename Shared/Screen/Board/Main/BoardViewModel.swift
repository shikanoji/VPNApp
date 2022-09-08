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
            mesh.currentTab = tab
        }
    }
    
    @Published var uploadSpeed: String = "0"
    @Published var downloadSpeed: String = "0"
    @Published var nodeConnected: Node? = nil {
        didSet {
            if let node = nodeConnected {
                self.isSwitching = state == .connected
                NetworkManager.shared.selectNode = node
                self.connectOrDisconnectByUser = true
                self.ConnectOrDisconnectVPN()
            }
        }
    }
    
    @Published var locationData: [NodeGroup] = []
    
    @Published var staticIPData: [StaticServer] = []
    @Published var staticIPNodeSelecte: StaticServer? = nil {
        didSet {
            if let staticIP = staticIPNodeSelecte {
                self.isSwitching = state == .connected
                NetworkManager.shared.selectStaticServer = staticIP
                self.connectOrDisconnectByUser = true
                self.ConnectOrDisconnectVPN()
            }
        }
    }
    
    @Published var mutilhopList: [MultihopModel] = []
    @Published var multihopSelect: MultihopModel? = nil {
        didSet {
            if let multihop = multihopSelect {
                self.isSwitching = state == .connected
                NetworkManager.shared.selectMultihop = multihop
                self.connectOrDisconnectByUser = true
                self.ConnectOrDisconnectVPN()
            }
        }
    }
    
    @Published var mesh: Mesh = Mesh()
    
    @Published var showAlert: Bool = false {
        didSet {
            if showAlert {
                state = .disconnected
            }
        }
    }
    
    @Published var showAlertAutoConnectSetting: Bool = false
    
    @Published var showAlertSessionSetting: Bool = false
    @Published var shouldHideSession = true
    
    @Published var showProgressView: Bool = false
    
    var disconnectBeforeConnecting = false
    var isProcessingVPN = false
    
    var checkStateFirstLoad = true
    
    var error: APIError?
    
    let disposedBag = DisposeBag()
    
    var isSwitching = false
    
    // MARK: Function
    
    var firstLoad = true
    
    init() {
        tab = AppSetting.shared.getCurrentTab()
        
        getDataFromLocal()
        getDataUpdate()
        getMultihopList()
        
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
            selector: #selector(checkInternetRealTimeForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(checkInternetRealTime),
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

        Task {
            await OpenVPNManager.shared.vpn.prepare()
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: .main) { _ in
            NetworkManager.shared.disconnect()
        }
        
        checkInternetRealTime()
        
        assignJailBreakCheckType(type: .readAndWriteFiles)
        AppSetting.shared.fetchListSession()
    }
    
    @objc private func logoutNeedDisconnect() {
        configDisconnect()
    }
    
    @objc private func disconnectCurrentSession() {
        configDisconnect()
    }
    
    func getDataUpdate() {
        AppSetting.shared.getIpInfo { _ in
            self.getCountryList()
        }
    }
    
    @Published var shouldHideAutoConnect = true
    
    var isCheckingAutoConnect = false
    
    @objc private func checkInternetRealTimeForeground() {
        if state != .connected {
            checkInternetRealTime()
        }
    }
    
    @objc private func autoConnectWithConfig() {
        if Connectivity.sharedInstance.isReachable, !isProcessingVPN {
            switch self.autoConnectType {
            case .always:
                ConnectOrDisconnectVPN()
            case .onWifi:
                if Connectivity.sharedInstance.isReachableOnEthernetOrWiFi {
                    ConnectOrDisconnectVPN()
                }
            case .onMobile:
                if Connectivity.sharedInstance.isReachableOnCellular {
                    ConnectOrDisconnectVPN()
                }
            default:
                break
            }
        }
    }
    
    func ConnectOrDisconnectVPN() {
        switch autoConnectType {
        case .off:
            if connectOrDisconnectByUser {
                switch state {
                case .disconnected:
                    configStartConnectVPN()
                default:
                    configDisconnect()
                }
            }
        default:
            if connectOrDisconnectByUser {
                showAlertAutoConnectSetting = true
            } else {
                if !isProcessingVPN {
                    switch state {
                    case .disconnected:
                        configStartConnectVPN()
                    default:
                        break
                    }
                }
            }
        }
    }
    
    func configDisconected() {
        if state == .connected {
            disconnectSession()
        }
        connectOrDisconnectByUser = false
        state = .disconnected
        stateUI = .disconnected
        ip = AppSetting.shared.ip
        flag = ""
        stopSpeedTimer()
        nameSelect = ""
        isProcessingVPN = false
        
        if isSwitching {
            isSwitching = false
            configStartConnectVPN()
        }
    }
    
    func configDisconnect() {
        connectOrDisconnectByUser = true
        stopSpeedTimer()
        numberReconnect = 0
        stateUI = .disconnected
        isCheckingAutoConnect = false
        isProcessingVPN = true
        NetworkManager.shared.disconnect()
    }
    
    func configStartConnectVPN() {
        if state == .disconnected {
            disconnectBeforeConnecting = false
            numberReconnect = 0
            isProcessingVPN = true
            stateUI = .connecting
            startConnectVPN()
        }
    }
    
    func startConnectVPN() {
        getRequestCertificate {
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
    
    func configConnected() {
        state = .connected
        stateUI = .connected
        numberReconnect = 0
        connectOrDisconnectByUser = false
        stopSpeedTimer()
        
        switch tab {
        case .location:
            if let iPVPN = NetworkManager.shared.requestCertificate?.server?.ipAddress {
                ip = iPVPN
            }
            
            if let nodeSelect = NetworkManager.shared.getNodeConnect() {
                flag = nodeSelect.flag
                nameSelect = nodeSelect.isCity ? nodeSelect.name : nodeSelect.countryName
            }
            
        case .staticIP, .multiHop:
            if let iPWireguard = NetworkManager.shared.requestCertificate?.server?.ipAddress {
                ip = iPWireguard
            }

            flag = NetworkManager.shared.selectStaticServer?.flag ?? ""
            nameSelect = NetworkManager.shared.selectStaticServer?.countryName ?? ""
        }
        getSpeedRealTime()

        isProcessingVPN = false
    }
    
    @objc private func VPNStatusDidChange(notification: Notification) {
       
        print("VPNStatusDidChange: \(notification.vpnStatus)")
        switch notification.vpnStatus {
        case .connected:
            if firstLoad {
                configConnected()
                firstLoad = false
            }
            
            guard isProcessingVPN else {
                return
            }
            
            guard disconnectBeforeConnecting else {
                return
            }
            
            guard state == .connecting else {
                return
            }

            configConnected()
            
        case .disconnected:
            if firstLoad {
                configDisconected()
                firstLoad = false
            }
            
            if !disconnectBeforeConnecting {
                disconnectBeforeConnecting = true
            }
            
            if state == .disconnecting {
                if (isEnableReconect && !connectOrDisconnectByUser) {
                    startConnectVPN()
                } else {
                    configDisconected()
                }
            } else if state == .connecting || (state == .connected && !isProcessingVPN) {
                configDisconected()
            }
            
        default:
            state = notification.vpnStatus
        }
    }
    
    @MainActor @objc private func VPNDidFail(notification: Notification) {
        print("VPNStatusDidFail: \(notification.vpnError.localizedDescription)")
        
        stopSpeedTimer()
        configDisconected()
        if isEnableReconect, !connectOrDisconnectByUser {
            startConnectVPN()
        }
    }
    
    var checkInternetTimer: DispatchSourceTimer?
    
    var autoConnectType = ItemCell(type: AppSetting.shared.getAutoConnectProtocol()).type
    
    @objc func checkInternetRealTime() {
        print("checkInternetRealTime")
        
        autoConnectType = ItemCell(type: AppSetting.shared.getAutoConnectProtocol()).type
        
        if autoConnectType == .off {
            stopAutoconnectTimer()
            return
        }
        
        guard !isCheckingAutoConnect else {
            return
        }
        
        isCheckingAutoConnect = true
        
        stopAutoconnectTimer()
        let queue = DispatchQueue.main
        checkInternetTimer = DispatchSource.makeTimerSource(queue: queue)
        checkInternetTimer!.schedule(deadline: .now(), repeating: .seconds(5))
        checkInternetTimer!.setEventHandler { [weak self] in
            switch self?.autoConnectType {
            case .always, .onWifi, .onMobile:
                if self?.state == .disconnected && !(self?.isProcessingVPN ?? false) {
                    self?.autoConnectWithConfig()
                }
            default:
                break
            }
        }
        checkInternetTimer!.resume()
    }
    
    var speedTimer: DispatchSourceTimer?
    
    func getSpeedRealTime() {
        let queue = DispatchQueue.main
        speedTimer = DispatchSource.makeTimerSource(queue: queue)
        speedTimer!.schedule(deadline: .now(), repeating: .seconds(1))
        speedTimer!.setEventHandler { [weak self] in
            if (NetworkManager.shared.selectConfig == .openVPNTCP || NetworkManager.shared.selectConfig == .openVPNUDP),
               let dataCount = OpenVPNManager.shared.getDataCount() {
                self?.uploadSpeed = dataCount.sent.descriptionAsDataUnit
                self?.downloadSpeed = dataCount.received.descriptionAsDataUnit
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
    }
    
    func internetNotAvaiable() {
        self.error = APIError.noInternet
        self.showProgressView = false
        self.showAlert = true
    }
    
    func getCountryList() {
        guard Connectivity.sharedInstance.isReachable else {
            internetNotAvaiable()
            return
        }
        
        self.showProgressView = true
        
        ServiceManager.shared.getCountryList()
            .subscribe { [weak self] response in
                guard let `self` = self else {
                    return
                }
                self.showProgressView = false
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
                self.showProgressView = false
                self.error = APIError.identified(message: error.localizedDescription)
                self.showAlert = true
            }
            .disposed(by: disposedBag)
    }
    
    func getMultihopList() {
        guard Connectivity.sharedInstance.isReachable else {
            internetNotAvaiable()
            return
        }
        
        ServiceManager.shared.getMutihopList()
            .subscribe { [weak self] response in
                guard let `self` = self else {
                    return
                }
                
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
                    
                } else {
                    //No multi-hop
                }
            } onFailure: { error in
                // Error
            }
            .disposed(by: disposedBag)
    }
    
    func prepareConnect(completion: @escaping (Bool) -> Void) {
        switch NetworkManager.shared.selectConfig {
        case .openVPNTCP, .recommend, .openVPNUDP:
            AppSetting.shared.currentSessionId = NetworkManager.shared.requestCertificate?.sessionId ?? ""
            completion(true)
        case .wireGuard:
            numberCallObtainCer = 0
            getObtainCertificate() {
                if self.isEnableReconect {
                    self.getRequestCertificate {
                        completion($0)
                    }
                } else {
                    completion($0)
                }
            }
        default:
            break
        }
    }
    
    let maximumCallObtainCer = 50
    var numberCallObtainCer = 0
    
    func getObtainCertificate(completion: @escaping (Bool) -> Void) {
        guard Connectivity.sharedInstance.isReachable else {
            internetNotAvaiable()
            return
        }
        numberCallObtainCer += 1
        
        ServiceManager.shared.getObtainCertificate()
            .subscribe { [weak self] response in
                guard let `self` = self else {
                    return
                }
                
                self.showProgressView = false
                
                if let result = response.result {
                    NetworkManager.shared.obtainCertificate = result
                    AppSetting.shared.currentSessionId = result.sessionId ?? ""
                    completion(true)
                } else if response.success {
                    if self.numberCallObtainCer >= self.maximumCallObtainCer {
                        completion(false)
                    } else {
                        self.getObtainCertificate() {
                            completion($0)
                        }
                    }
                } else {
                    let error = response.errors
                    if error.count > 0, let message = error[0] as? String {
                        self.error = APIError.identified(message: message)
                        self.showAlert = true
                    } else if !response.message.isEmpty {
                        self.error = APIError.identified(message: response.message)
                        self.showAlert = true
                    }
                    completion(false)
                }
            } onFailure: { error in
                self.error = APIError.identified(message: error.localizedDescription)
                self.showProgressView = false
                self.showAlert = true
                completion(false)
            }
            .disposed(by: disposedBag)
    }
    
    func getRequestCertificate(asNewConnection: Bool = false, completion: @escaping (Bool) -> Void) {
        guard isEnableReconect else {
            completion(false)
            return
        }
        
        numberReconnect += 1
        
        guard Connectivity.sharedInstance.isReachable else {
            internetNotAvaiable()
            return
        }
        ServiceManager.shared.getRequestCertificate(currentTab: tab, asNewConnection: asNewConnection)
            .subscribe { [weak self] response in
                guard let `self` = self else {
                    return
                }
                
                self.showProgressView = false
                
                if let result = response.result {
                    switch NetworkManager.shared.selectConfig {
                    case .openVPNTCP, .recommend, .openVPNUDP:
                        if let cer = result.getRequestCer {
                            if !cer.exceedLimit {
                                if cer.allowReconnect {
                                    NetworkManager.shared.requestCertificate = cer
                                    AppSetting.shared.currentSessionId = NetworkManager.shared.requestCertificate?.sessionId ?? ""
                                    completion(true)
                                    return
                                } else {
                                    self.getRequestCertificate(asNewConnection: true) {
                                        completion($0)
                                        return
                                    }
                                }
                               
                            } else {
                                completion(false)
                                self.showAlertSessionSetting = true
                                return
                            }
                        } else if self.isEnableReconect {
                            self.getRequestCertificate() {
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
                            NetworkManager.shared.obtainCertificate = cer
                            AppSetting.shared.currentSessionId = cer.sessionId ?? ""
                            completion(true)
                            return
                        } else {
                            self.stateUI = .disconnected
                            completion(false)
                            return
                        }
                    default:
                        break
                    }
                } else {
                    if self.isEnableReconect {
                        self.getRequestCertificate() {
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
                    self.getRequestCertificate() {
                        completion($0)
                        return
                    }
                } else {
                    self.error = APIError.identified(message: error.localizedDescription)
                    self.showProgressView = false
                    self.showAlert = true
                    completion(false)
                    return
                }
            }
            .disposed(by: disposedBag)
    }
    
    func getAvaiableCity(_ cityNodes: [Node]) {
        if cityNodes.count > 0 {
            if let nodeLocal = NetworkManager.shared.selectNode {
                if cityNodes.filter({ nodeLocal.id == $0.id }).count == 0 {
                    NetworkManager.shared.selectNode = cityNodes.first
                }
            } else {
                NetworkManager.shared.selectNode = cityNodes.first
            }
        }
    }
    
    func getDataFromLocal() {
        if let dataMapLocal = AppSetting.shared.getDataMap() {
            configCountryList(dataMapLocal)
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
        
        self.mesh.configNode(countryNodes: countryNodes,
                             cityNodes: cityNodes,
                             staticNodes: staticIPData,
                             clientCountryNode: result.clientCountryDetail)
        
        var cityRecommendNodes = [Node]()
        result.recommendedCountries.forEach { cityRecommendNodes.append(contentsOf: $0.cityNodeList) }
        
        getAvaiableCity(cityRecommendNodes)
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
