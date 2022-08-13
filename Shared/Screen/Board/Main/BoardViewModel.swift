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

class BoardViewModel: ObservableObject {
    
    // MARK: Variable
    
    enum StateTab: Int {
        case location = 0
        case staticIP = 1
        case multiHop = 2
    }
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
    
    @Published var tab: StateTab = .location {
        didSet {
            mesh.currentTab = tab
        }
    }
    
    @Published var uploadSpeed: String = "0"
    @Published var downloadSpeed: String = "0"
    @Published var nodeConnected: Node? = nil {
        didSet {
            if let node = nodeConnected {
                NetworkManager.shared.selectNode = node
                self.ConnectOrDisconnectVPN()
            }
        }
    }
    
    @Published var locationData: [NodeGroup] = []
    
    @Published var staticIPData: [StaticServer] = []
    @Published var staticIPNodeSelecte: StaticServer? = nil {
        didSet {
            if let staticIP = staticIPNodeSelecte {
                NetworkManager.shared.selectStaticServer = staticIP
                self.ConnectOrDisconnectVPN()
            }
        }
    }
    
    @Published var mutilhopList: [MultihopModel] = []
    @Published var multihopSelect: MultihopModel? = nil {
        didSet {
            if let multihop = multihopSelect {
                NetworkManager.shared.selectMultihop = multihop
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
    
    var error: APIError?
    
    let disposedBag = DisposeBag()
    
    // MARK: Function
    
    init() {
        
        getDataFromLocal()
        getDataUpdate()
        getMultihopList()
        getDataFromLocal()
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

        Task {
            await OpenVPNManager.shared.vpn.prepare()
        }
        
        checkInternetRealTime()
        
        assignJailBreakCheckType(type: .readAndWriteFiles)
    }
    
    func getDataUpdate() {
        AppSetting.shared.getIpInfo { _ in
            self.getCountryList()
        }
    }
    
    var isProcessingVPN = false
    
    @Published var shouldHideAutoConnect = true
    
    var isCheckingAutoConnect = false
    
    @objc private func checkInternetRealTimeForeground() {
        if state != .connected {
            checkInternetRealTime()
        }
    }
    
    @objc private func checkAutoconnectIfNeeded() {
        guard let type = ItemCellType(rawValue: AppSetting.shared.selectAutoConnect) else {
            self.stopAutoconnectTimer()
            return
        }
        if type != .off {
            if Connectivity.sharedInstance.isReachable, !isProcessingVPN {
                switch type {
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
        } else {
           configDisconnect()
        }
    }
    
    func ConnectOrDisconnectVPN() {
        if connectOrDisconnectByUser {
            if let type = ItemCellType(rawValue: AppSetting.shared.selectAutoConnect),
               (type == .always || type == .onMobile || type == .onWifi) {
                if state != .disconnected {
                    showAlertAutoConnectSetting = true
                }
            } else {
                if isProcessingVPN || stateUI == .connecting || state == .connected {
                    configDisconnect()
                } else if state == .disconnected {
                    configStartConnectVPN()
                }
            }
        } else if !isProcessingVPN {
            if let type = ItemCellType(rawValue: AppSetting.shared.selectAutoConnect) {
                switch type {
                case .off:
                    configDisconnect()
                case .always, .onWifi, .onMobile:
                    if state == .disconnected {
                        configStartConnectVPN()
                    }
                default:
                    break
                }
            }
        }
    }
    
    var isDisconnecting = false
    
    func configDisconnect() {
        disconnectSession()
        stopSpeedTimer()
        numberReconnect = 0
        isProcessingVPN = false
        stateUI = .disconnected
        connectOrDisconnectByUser = false
        isCheckingAutoConnect = false
        isDisconnecting = true
        NetworkManager.shared.disconnect()
    }
    
    func configStartConnectVPN() {
        numberReconnect = 0
        isProcessingVPN = true
        stateUI = .connecting
        startConnectVPN()
    }
    
    func startConnectVPN() {
        getRequestCertificate {
            if $0 {
                NetworkManager.shared.connect()
            } else {
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
    
    @objc private func VPNStatusDidChange(notification: Notification) {
        
        print("VPNStatusDidChange: \(notification.vpnStatus)")
        switch notification.vpnStatus {
        case .connected:
            guard isProcessingVPN else {
                return
            }
            
            guard state == .connecting else {
                return
            }
            
            guard state != .connected else {
                return
            }
            
            state = .connected
            stateUI = .connected
            numberReconnect = 0
            connectOrDisconnectByUser = false
            stopSpeedTimer()
            
            switch NetworkManager.shared.selectConfig {
            case .openVPNTCP, .recommend, .openVPNUDP:
                if let iPVPN = NetworkManager.shared.requestCertificate?.server?.ipAddress {
                    ip = iPVPN
                }

                flag = NetworkManager.shared.selectNode?.flag ?? ""
                
                if let node = NetworkManager.shared.selectNode {
                    nameSelect = node.isCity ? node.name : node.countryName
                }
                
                case .wireGuard:
                if let iPWireguard = NetworkManager.shared.obtainCertificate?.server?.ipAddress {
                    ip = iPWireguard
                }

                flag = NetworkManager.shared.selectStaticServer?.flag ?? ""
                
                if let node = NetworkManager.shared.selectStaticServer {
                    nameSelect = node.countryName
                }
                
            default:
                break
            }
            getSpeedRealTime()
            
            isProcessingVPN = false
            
        case .disconnected:
            guard state != .disconnected else {
                return
            }
            
            guard state == .disconnecting else {
                return
            }
            
            if state == .disconnecting || state == .disconnected {
                if (isEnableReconect && !connectOrDisconnectByUser) && !isDisconnecting {
                    startConnectVPN()
                } else {
                    if connectOrDisconnectByUser {
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
                }
            }
            
        default:
            state = notification.vpnStatus
        }
    }
    
    @MainActor @objc private func VPNDidFail(notification: Notification) {
        print("VPNStatusDidFail: \(notification.vpnError.localizedDescription)")
        
        stopSpeedTimer()
        
        state = .disconnected
        stateUI = .disconnected
        
        if isEnableReconect, !connectOrDisconnectByUser {
            startConnectVPN()
        }
    }
    
    var checkInternetTimer: DispatchSourceTimer?
    
    @objc func checkInternetRealTime() {
        print("checkInternetRealTime")
        guard let type = ItemCellType(rawValue: AppSetting.shared.selectAutoConnect) else {
            self.checkInternetTimer = nil
            return
        }
        
        if type == .off {
            switch self.stateUI {
            case .connected:
                self.configDisconnect()
            default:
                break
            }
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
            switch type {
            case .off:
                self?.configDisconnect()
            case .always, .onWifi, .onMobile:
                if self?.state != .connected && !(self?.isProcessingVPN ?? false) {
                    self?.checkAutoconnectIfNeeded()
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
        
        APIManager.shared.getCountryList()
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
        
        APIManager.shared.getMutihopList()
            .subscribe { [weak self] response in
                guard let `self` = self else {
                    return
                }
                
                if let result = response.result {
                    AppSetting.shared.saveMutilhopList(result)
                    self.mutilhopList = result
                    
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
        
        APIManager.shared.getObtainCertificate()
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
    
    func getRequestCertificate(completion: @escaping (Bool) -> Void) {
        guard isEnableReconect else {
            completion(false)
            return
        }
        
        numberReconnect += 1
        
        guard Connectivity.sharedInstance.isReachable else {
            internetNotAvaiable()
            return
        }
        APIManager.shared.getRequestCertificate(currentTab: tab)
            .subscribe { [weak self] response in
                guard let `self` = self else {
                    return
                }
                
                self.showProgressView = false
                
                if let result = response.result {
                    switch NetworkManager.shared.selectConfig {
                    case .openVPNTCP, .recommend, .openVPNUDP:
                        print("APIManager.shared.getRequestCertificate switch NetworkManager.shared.selectConfig")
                        if let cer = result.getRequestCer {
                            if !cer.exceedLimit {
                                NetworkManager.shared.requestCertificate = cer
                                AppSetting.shared.currentSessionId = NetworkManager.shared.requestCertificate?.sessionId ?? ""
                                completion(true)
                            } else {
                                self.showAlertSessionSetting = true
                            }
                        } else if self.isEnableReconect {
                            self.getRequestCertificate() {
                                completion($0)
                            }
                        } else {
                            self.stateUI = .disconnected
                            completion(false)
                        }
                    case .wireGuard:
                        if let cer = result.getObtainCer {
                            NetworkManager.shared.obtainCertificate = cer
                            AppSetting.shared.currentSessionId = cer.sessionId ?? ""
                            completion(true)
                        }
                        self.stateUI = .disconnected
                        completion(false)
                    default:
                        break
                    }
                } else {
                    if self.isEnableReconect {
                        self.getRequestCertificate() {
                            completion($0)
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
                    }
                }
            } onFailure: { error in
                if self.isEnableReconect {
                    self.getRequestCertificate() {
                        completion($0)
                    }
                } else {
                    self.configDisconnect()
                    self.error = APIError.identified(message: error.localizedDescription)
                    self.showProgressView = false
                    self.showAlert = true
                }
            }
            .disposed(by: disposedBag)
    }
    
    func getAvaiableCity(_ cityNodes: [Node]) {
        if cityNodes.count > 0 {
            NetworkManager.shared.selectNode = cityNodes.first
        }
    }
    
    func getDataFromLocal() {
        if let dataMapLocal = AppSetting.shared.getDataMap() {
            configCountryList(dataMapLocal)
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
        
        NetworkManager.shared.selectStaticServer = staticIPData.first
        
        self.mesh.configNode(countryNodes: countryNodes,
                             cityNodes: cityNodes,
                             staticNodes: staticIPData,
                             clientCountryNode: result.clientCountryDetail)
        
        var cityRecommendNodes = [Node]()
        result.recommendedCountries.forEach { cityRecommendNodes.append(contentsOf: $0.cityNodeList) }
        
        getAvaiableCity(cityRecommendNodes)
    }
    
    func disconnectSession() {
        APIManager.shared.disconnectSession(sessionId: AppSetting.shared.currentSessionId, terminal: false)
            .subscribe { [weak self] response in
                guard let `self` = self else {
                    return
                }
                
                self.showProgressView = false
                
                if response.success {
                  
                } else {
//                    let error = response.errors
//                    if error.count > 0, let message = error[0] as? String {
//                        self.error = APIError.identified(message: message)
//                        self.showAlert = true
//                    } else if !response.message.isEmpty {
//                        self.error = APIError.identified(message: response.message)
//                        self.showAlert = true
//                    }
                }
            } onFailure: { error in
//                self.error = APIError.identified(message: error.localizedDescription)
//                self.showAlert = true
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
