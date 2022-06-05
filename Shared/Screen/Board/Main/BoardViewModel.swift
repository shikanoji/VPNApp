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
            return L10n.Board.connected
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
    
    enum StateTab: Int {
        case location = 0
        case staticIP = 1
        case multiHop = 2
    }
    @Published var showAutoConnect: Bool = false
    @Published var showProtocolConnect: Bool = false
    @Published var showDNSSetting: Bool = false
    @Published var state: VPNStatus = .disconnected
    @Published var ip = AppSetting.shared.ip
    @Published var flag = ""
    @Published var nodes: [Node] = []
    @Published var errorMessage: String? = nil
    
    @Published var tab: StateTab = .location {
        didSet {
            mesh.currentTab = tab
        }
    }
    
    @Published var uploadSpeed: CGFloat = 0.0
    @Published var downloadSpeed: CGFloat = 0.0
    @Published var nodeConnected: Node? = nil {
        didSet {
            if let node = nodeConnected {
                NetworkManager.shared.selectNode = node
                self.connectVPN()
            }
        }
    }
    
    @Published var locationData: [NodeGroup] = []
    
    @Published var staticIPData: [StaticServer] = []
    @Published var staticIPNodeSelecte: StaticServer? = nil {
        didSet {
            if let staticIP = staticIPNodeSelecte {
                NetworkManager.shared.selectStaticServer = staticIP
                self.connectVPN()
            }
        }
    }
    
    @Published var mutilhopData: [(Node, Node)] = [(Node.country, Node.tokyo), (Node.country, Node.tokyo)]
    
    @Published var entryNodeListMutilhop: [Node] = Node.all
    @Published var exitNodeListMutilhop: [Node] = Node.all
    @Published var entryNodeSelectMutilhop: Node = Node.country
    @Published var exitNodeSelectMutilhop: Node = Node.tokyo
    @Published var mesh: Mesh = Mesh()
    
    @Published var showAlert: Bool = false {
        didSet {
            if showAlert {
                state = .disconnected
            }
        }
    }
    
    @Published var showAlertAutoConnectSetting: Bool = false
    
    @Published var showProgressView: Bool = false
    
    var error: APIError?
    
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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(checkInternetRealTime),
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
    
    var isProcessingVPN = false
    
    @Published var shouldHideAutoConnect = true
    
    @objc private func checkAutoconnectIfNeeded() {
        if let type = ItemCellType(rawValue: AppSetting.shared.selectAutoConnect) {
            if type != .off {
                if state == .disconnected, !isProcessingVPN {
                    if Connectivity.sharedInstance.isReachable {
                        switch type {
                        case .always:
                            connectVPN()
                        case .onWifi:
                            if Connectivity.sharedInstance.isReachableOnEthernetOrWiFi {
                                connectVPN()
                            }
                        case .onMobile:
                            if Connectivity.sharedInstance.isReachableOnCellular {
                                connectVPN()
                            }
                        default:
                            stopAutoconnectTimer()
                        }
                    }
                }
            } else if type == .off {
                NetworkManager.shared.disconnect()
                stopAutoconnectTimer()
            }
        }
    }
    
    func connectVPN() {
        if state == .disconnected {
            getRequestCertificate()
        } else {
            if let type = ItemCellType(rawValue: AppSetting.shared.selectAutoConnect),
               (type == .always || type == .onMobile || type == .onWifi) {
                showAlertAutoConnectSetting = true
            } else {
                NetworkManager.shared.disconnect()
            }
        }
    }
    
    let maximumReonnect = 7
    var numberReconnect = 0
    var disconnectByUser = false
    
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
            
            state = .connected
            numberReconnect = 0
            disconnectByUser = false
            stopSpeedTimer()
            
            switch NetworkManager.shared.selectConfig {
            case .openVPN, .recommend:
                if let iPVPN = NetworkManager.shared.requestCertificate?.server?.ipAddress {
                    ip = iPVPN
                }

                flag = NetworkManager.shared.selectNode?.flag ?? ""

            case .wireGuard:
                if let iPWireguard = NetworkManager.shared.obtainCertificate?.server?.ipAddress {
                    ip = iPWireguard
                }

                flag = NetworkManager.shared.selectStaticServer?.flag ?? ""
            default:
                break
            }
            getSpeedRealTime()
            
            isProcessingVPN = false
            
        case .disconnected:
            guard isProcessingVPN else {
                return
            }
            
            if state == .disconnecting {
                state = .disconnected
                ip = AppSetting.shared.ip
                flag = ""
                stopSpeedTimer()
                disconnectByUser = true
                
                isProcessingVPN = false
                
                if numberReconnect < maximumReonnect, !disconnectByUser {
                    numberReconnect += 1
                    connectVPN()
                }
            }
            
        default:
            state = notification.vpnStatus
            isProcessingVPN = true
        }
    }
    
    @MainActor @objc private func VPNDidFail(notification: Notification) {
        print("VPNStatusDidFail: \(notification.vpnError.localizedDescription)")
        
        stopSpeedTimer()
        state = .disconnected
        
        if numberReconnect < maximumReonnect, !disconnectByUser  {
            connectVPN()
            numberReconnect += 1
        }
    }
    
    var checkInternetTimer: DispatchSourceTimer?
    
    @objc func checkInternetRealTime() {
        stopAutoconnectTimer()
        let queue = DispatchQueue.main
        checkInternetTimer = DispatchSource.makeTimerSource(queue: queue)
        checkInternetTimer!.schedule(deadline: .now(), repeating: .seconds(5))
        checkInternetTimer!.setEventHandler { [weak self] in
            self?.checkAutoconnectIfNeeded()
        }
        checkInternetTimer!.resume()
    }
    
    var speedTimer: DispatchSourceTimer?
    
    func getSpeedRealTime() {
        let queue = DispatchQueue.main
        speedTimer = DispatchSource.makeTimerSource(queue: queue)
        speedTimer!.schedule(deadline: .now(), repeating: .seconds(1))
        speedTimer!.setEventHandler { [weak self] in
            if NetworkManager.shared.selectConfig == .openVPN,
               let dataCount = OpenVPNManager.shared.getDataCount() {
                self?.uploadSpeed = CGFloat(dataCount.sent) * 0.001
                self?.downloadSpeed = CGFloat(dataCount.received) * 0.001
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
    
    func prepareConnect(completion: @escaping (Bool) -> Void) {
        switch NetworkManager.shared.selectConfig {
        case .openVPN, .recommend:
            completion(true)
        case .wireGuard:
            numberCallObtainCer = 0
            getObtainCertificate() {
                completion($0)
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
    
    func getRequestCertificate() {
        guard Connectivity.sharedInstance.isReachable else {
            internetNotAvaiable()
            return
        }
        self.showProgressView = true
        APIManager.shared.getRequestCertificate(currentTab: tab)
            .subscribe { [weak self] response in
                guard let `self` = self else {
                    return
                }
                
                self.showProgressView = false
                
                if let result = response.result {
                    NetworkManager.shared.requestCertificate = result
                    self.prepareConnect() { start in
                        if start {
                            NetworkManager.shared.connect()
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
            NetworkManager.shared.selectNode = cityNodes.first
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
        
        getAvaiableCity(cityNodes)
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
