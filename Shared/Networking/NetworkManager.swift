//
//  NetworkManager.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 20/04/2022.
//

import Foundation
import UIKit
import RxSwift
import SwiftUI
import TunnelKitManager
import TunnelKitCore
import Network
import NetworkExtension

extension ItemCellType {
    var getConfigParam: String {
        switch self {
        case .openVPNTCP, .recommended, .openVPNUDP:
            return "ovpn"
        case .wireGuard:
            return "wg"
        default:
            return ""
        }
    }
    
    var getProtocolVPN: String {
        switch self {
        case .openVPNTCP:
            return "tcp"
        default:
            return "udp"
        }
    }
}

enum ErrorBoardView {
    case fullSession
    case sessionTerminate
    case apiError(APIError)
    case autoConnecting
    case authenNotPremium
}

class NetworkManager: ObservableObject {
    
    static var shared = NetworkManager()
    
    var stateUI: VPNStatus = .disconnected {
        didSet {
            stateUICallBack?(stateUI)
        }
    }
    
    var state: VPNStatus = .disconnected {
        didSet {
            stateCallBack?(state)
        }
    }
    
    var stateCallBack: ((VPNStatus) -> Void)?
    var stateUICallBack: ((VPNStatus) -> Void)?
    var errorCallBack: ((ErrorBoardView) -> Void)?
    
    var showProgressView = false
    var needReconnect = false
    var connectOrDisconnectByUser = false
    var isReconnect = false
    var showAlert = false
    
    var selectConfig: ItemCellType {
        get {
            let type = AppSetting.shared.getConfigProtocol()
            AppSetting.shared.selectConfig = type.rawValue
            return type
        }
        set {
            AppSetting.shared.selectConfig = newValue.rawValue
        }
    }
    
    var recommendConfig: ItemCellType {
        get {
            let type = AppSetting.shared.getRecommendConfigProtocol()
            return type
        }
        set {
            AppSetting.shared.recommendConfig = newValue.rawValue
        }
    }
    
    var getValueConfigProtocol : ItemCellType {
        return AppSetting.shared.getValueConfigProtocol()
    }
    
    var requestCertificate: RequestCertificateModel?
    
    var obtainCertificate: ObtainCertificateModel?
    
    var autoConnectType = ItemCell(type: AppSetting.shared.getAutoConnectProtocol()).type
    
    var nodeSelected: Node? {
        get {
            AppSetting.shared.getNodeSelect()
        }
        set {
            guard let data = newValue else {
                return
            }
            
            AppSetting.shared.saveNodeSelect(data)
        }
    }
    
    var selectStaticServer: StaticServer? {
        get {
            AppSetting.shared.getStaticSelect()
        }
        set {
            guard let data = newValue else {
                return
            }
            
            AppSetting.shared.saveStaticSelect(data)
        }
    }
    
    var selectMultihop: MultihopModel? {
        get {
            AppSetting.shared.getMultihopSelect()
        }
        set {
            guard let data = newValue else {
                return
            }
            
            AppSetting.shared.saveMultihopSelect(data)
        }
    }
    
    func connect() {
        switch getValueConfigProtocol {
        case .openVPNTCP, .openVPNUDP:
            OpenVPNManager.shared.connect()
        case .wireGuard:
            WireGuardManager.shared.connect()
        default:
            break
        }
    }
    
    func disconnect() {
        switch getValueConfigProtocol {
        case .openVPNTCP, .openVPNUDP:
            OpenVPNManager.shared.disconnect()
        case .wireGuard:
            WireGuardManager.shared.disconnect()
        default:
            break
        }
    }
    
    var nodeConnecting: Node? {
        get {
            AppSetting.shared.getNodeConnecting()
        }
        set {
            guard let data = newValue else {
                return
            }
            
            AppSetting.shared.saveNodeConnecting(data)
        }
    }
    
    func getNodeConnect() -> Node? {
        checkAutoconnect()
        if networkConnectIsCurrentNetwork() {
            return AppSetting.shared.getAutoConnectNodeToConnect()
        } else {
            return nodeSelected
        }
    }
    
    init() {
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
            selector: #selector(configAutoConnect),
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
            selector: #selector(connectVPNError),
            name: Constant.NameNotification.connectVPNError,
            object: nil
        )
        
        beginBackgroundTask()
        
        Connectivity.sharedInstance.enableNetworkCallBack = {
            if $0 {
                if self.lostNetworkAfterConnect {
                    self.stateUI = self.state
                    self.lostNetworkAfterConnect = false
                }
            } else {
                if self.state == .connected, AppSetting.shared.isConnectedToVpn, !self.lostNetworkAfterConnect {
                    self.lostNetworkAfterConnect = true
                    self.stateUI = .connecting
                    self.loadingRequestCertificate = false
                }
            }
        }
        
        Connectivity.sharedInstance.enableWifiCallBack = {
            print("enableWifiCallBack \($0)")
        }
        
        Connectivity.sharedInstance.enableCellularCallBack = {
            print("enableCellularCallBack \($0)")
        }
    }
    
    var lostNetworkAfterConnect = false
    
    @objc
    func connectVPNError() {
        loadingRequestCertificate = false
        state = .disconnected
        stateUI = .disconnected
    }
    
    @objc
    func configAutoConnect() {
        checkAutoconnect()
        
        if networkConnectIsCurrentNetwork() && state == .disconnected  {
            autoConnectWithConfig()
        }
    }
    
    @objc private func disconnectCurrentSession() {
        onlyDisconnectWithoutEndsession = true
        configDisconnect()
        AppSetting.shared.selectAutoConnect = ItemCellType.off.rawValue
        checkAutoconnect()
    }
    
    func checkConnectedVPNLostNetwork() {
        if AppSetting.shared.isConnectedToVpn && !Connectivity.sharedInstance.enableNetwork {
            if stateUI == .connected {
                connectOrDisconnectByUser = true
                configDisconnect()
            }
        }
    }
    
    @objc private func autoConnectWithConfig() {
        if Connectivity.sharedInstance.enableNetwork {
            switch autoConnectType {
            case .always:
                AppSetting.shared.saveBoardTabWhenConnecting(.location)
                ConnectOrDisconnectVPN()
            case .onWifi:
                if Connectivity.sharedInstance.enableWifi {
                    AppSetting.shared.saveBoardTabWhenConnecting(.location)
                    ConnectOrDisconnectVPN()
                }
            case .onMobile:
                if Connectivity.sharedInstance.enableCellular {
                    AppSetting.shared.saveBoardTabWhenConnecting(.location)
                    ConnectOrDisconnectVPN()
                }
            default:
                break
            }
        }
    }
    
    deinit {
        endBackgroundTask()
    }
    
    private var backgroundTaskId: UIBackgroundTaskIdentifier?
    
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
    
    func ConnectOrDisconnectVPN() {
        checkAutoconnect()
        switch autoConnectType {
        case .off:
            switch stateUI {
            case .disconnected:
                AppSetting.shared.saveTimeConnectedVPN = nil
                configStartConnectVPN()
            case .connecting, .disconnecting:
                configDisconnect()
            default:
                connectOrDisconnectByUser = true
                configDisconnect()
            }
        default:
            if connectOrDisconnectByUser, stateUI != .disconnected {
                if networkConnectIsCurrentNetwork() {
                    errorCallBack?(.autoConnecting)
                } else {
                    configDisconnect()
                }
            } else {
                switch state {
                case .disconnected:
                    AppSetting.shared.saveTimeConnectedVPN = nil
                    configStartConnectVPN()
                default:
                    configDisconnect()
                }
            }
        }
    }
    
    let maximumReconnect = 3
    var numberReconnect = 0
    
    let disposedBag = DisposeBag()
    
    var isEnableReconect: Bool {
        get { numberReconnect < maximumReconnect }
    }
    
    func startConnectVPN(asNewConnection: Bool) {
        loadingRequestCertificate = true
        getRequestCertificate(asNewConnection: asNewConnection) {
            if $0 {
                self.connect()
            } else {
                if self.isReconnect {
                    self.isReconnect = false
                }
                self.stateUI = .disconnected
                self.state = .disconnected
            }
            self.loadingRequestCertificate = false
        }
    }
    
    func configDisconnect() {
        numberReconnect = 0
        disconnect()
    }
    
    @MainActor @objc private func VPNDidFail(notification: Notification) {
        print("VPNStatusDidFail: \(notification.vpnError.localizedDescription)")
        guard notification.vpnError.localizedDescription != "permission denied" else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.configDisconected()
            })
            return
        }
        configDisconected()
        if isEnableReconect, !connectOrDisconnectByUser {
            startConnectVPN(asNewConnection: false)
        }
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
        
        switch state {
        case .connected:
            configConnected()
        case .disconnected:
            if AppSetting.shared.isConnectedToVpn {
                configStartConnectVPN()
                return
            }
            
            if isEnableReconect,
               !connectOrDisconnectByUser {
                startConnectVPN(asNewConnection: false)
            } else {
                configDisconected()
            }
        default:
            break
        }
    }
    
    var onlyDisconnectWithoutEndsession = false
    
    func checkVPN() {
        if AppSetting.shared.isConnectedToVpn && Connectivity.sharedInstance.enableNetwork {
            if state == .disconnected {
                configConnected()
            }
        } else {
            if state != .disconnected && state != .disconnecting {
                configDisconnect()
            }
        }
    }
    
    func reconnectVPN() {
        needReconnect = true
        configDisconnect()
    }
    
    func checkVPNKill() {
//        checkVPN()
//        if AppSetting.shared.isConnectedToVpn {
        reconnectVPN()
//            if !Connectivity.sharedInstance.isReachable {
//                reconnectVPN()
//            } else {
//                pingGoogleCheckInternet {
//                    if !$0 {
//                        self.reconnectVPN()
//                    }
//                }
//            }
//        }
    }
    
    func networkConnectIsCurrentNetwork() -> Bool {
        switch autoConnectType {
        case .always:
            return Connectivity.sharedInstance.enableNetwork
        case .onWifi:
            return Connectivity.sharedInstance.enableWifi
        case .onMobile:
            return Connectivity.sharedInstance.enableCellular
        default:
            return false
        }
    }
    
    func pingGoogleCheckInternet(completion: @escaping (Bool) -> Void) {
        ServiceManager.shared.ping()
            .subscribe(onSuccess: { [self] response in
                completion(true)
            }, onFailure: { error in
                completion(false)
            })
            .disposed(by: disposedBag)
    }
    
    @objc
    func configDisconected() {
        DispatchQueue.main.async {
            self.state = .disconnected
            self.stateUI = .disconnected
        }
        if onlyDisconnectWithoutEndsession {
            disconnectSession()
            onlyDisconnectWithoutEndsession = false
        }
        if needReconnect {
            needReconnect = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.configStartConnectVPN()
            }
        }
        
        AppSetting.shared.lineNetwork = 0
        if connectOrDisconnectByUser {
            AppSetting.shared.currentSessionId = ""
        }
        
        connectOrDisconnectByUser = false
        AppSetting.shared.saveTimeConnectedVPN = nil
    }
    
    func configStartConnectVPN() {
        if state == .disconnected {
            numberReconnect = 0
            stateUI = .connecting
            startConnectVPN(asNewConnection: true)
        }
    }
    
    func disconnectSession() {
        ServiceManager.shared.disconnectSession(sessionId: AppSetting.shared.currentSessionId, terminal: false)
            .subscribe { [weak self] response in
                guard self != nil else {
                    return
                }
                
                if response.success {
                  
                } else {

                }
            } onFailure: { error in
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
        AppSetting.shared.fetchListSession()
    }
    
    var loadingRequestCertificate = false
    
    func getRequestCertificate(asNewConnection: Bool = true, completion: @escaping (Bool) -> Void) {
        guard isEnableReconect else {
            completion(false)
            return
        }
        
        numberReconnect += 1
        
        guard Connectivity.sharedInstance.enableNetwork else {
            configDisconected()
            errorCallBack?(.apiError(.noInternet))
            return
        }
        
        ServiceManager.shared.getRequestCertificate(asNewConnection: asNewConnection)
            .subscribe { [weak self] response in
                guard let self = self else {
                    return
                }
                if let result = response.result {
                    switch NetworkManager.shared.getValueConfigProtocol {
                    case .openVPNTCP, .openVPNUDP:
                        if let cer = result.getRequestCer {
                            if !cer.exceedLimit {
                                if cer.allowReconnect {
                                    NetworkManager.shared.requestCertificate = cer
                                    AppSetting.shared.currentSessionId = NetworkManager.shared.requestCertificate?.sessionId ?? ""
                                    completion(true)
                                    return
                                } else {
                                    self.errorCallBack?(.sessionTerminate)
                                    completion(false)
                                    return
                                }
                            } else {
                                self.errorCallBack?(.fullSession)
                                completion(false)
                                return
                            }
                        } else if self.isEnableReconect {
                            self.getRequestCertificate(asNewConnection: true) {
                                completion($0)
                                return
                            }
                        } else {
                            completion(false)
                            return
                        }
                    case .wireGuard:
                        if let cer = result.getObtainCer {
                            if !cer.exceedLimit {
                                if cer.allowReconnect {
                                    NetworkManager.shared.obtainCertificate = cer
                                    AppSetting.shared.currentSessionId = cer.sessionId ?? ""
                                    completion(true)
                                    return
                                } else {
                                    self.errorCallBack?(.sessionTerminate)
                                    completion(false)
                                    return
                                }
                            } else {
                                completion(false)
                                self.errorCallBack?(.fullSession)
                                return
                            }
                        } else if self.isEnableReconect {
                            self.getRequestCertificate(asNewConnection: true) {
                                completion($0)
                                return
                            }
                        } else {
                            completion(false)
                            return
                        }
                    default:
                        completion(false)
                        return
                    }
                } else {
                    if self.isEnableReconect {
                        self.getRequestCertificate(asNewConnection: true) {
                            completion($0)
                            return
                        }
                    } else {
                        self.configDisconnect()
                        if response.code == 503 {
                            self.errorCallBack?(.authenNotPremium)
                            completion(false)
                            return
                        }
                        let error = response.errors
                        if !error.isEmpty, let message = error[0] as? String {
                            self.errorCallBack?(.apiError(APIError.identified(message: message)))
                        } else if !response.message.isEmpty {
                            self.errorCallBack?(.apiError(APIError.identified(message: response.message)))
                        }
                        completion(false)
                        return
                    }
                }
            } onFailure: { error in
                if self.isEnableReconect {
                    self.getRequestCertificate(asNewConnection: true) {
                        completion($0)
                        return
                    }
                } else {
                    if let errorConfig = error as? APIError {
                        self.errorCallBack?(.apiError(errorConfig))
                    }
                    completion(false)
                    return
                }
            }
            .disposed(by: disposedBag)
    }
    
    @objc func checkAutoconnect() {
        autoConnectType = ItemCell(type: AppSetting.shared.getAutoConnectProtocol()).type
    }
}
