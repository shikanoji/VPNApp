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

enum ErrorBoardView {
    case fullSession
    case sessionTerminate
    case apiError(AppAPIError)
    case autoConnecting
    case authenNotPremium
}

class NetworkManager {
    
    // MARK: - VARIABLE
    
    static var shared = NetworkManager()
    
    var stateUI: VPNStatus = AppSetting.shared.checkStateConnectedVPN ? .connected : .disconnected {
        didSet {
            stateUICallBack?(stateUI)
        }
    }
    
    var state: VPNStatus = AppSetting.shared.checkStateConnectedVPN ? .connected : .disconnected {
        didSet {
            stateCallBack?(state)
        }
    }
    
    var stateCallBack: ((VPNStatus) -> Void)?
    var stateUICallBack: ((VPNStatus) -> Void)?
    var errorCallBack: ((ErrorBoardView) -> Void)?
    
    var showProgressView = false
    var connectOrDisconnectByUser = false
    var isReconnect = false
    var showAlert = false
    
    var onlyDisconnectWithoutEndsession = false
    
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
    
    var requestCertificate: RequestCertificateModel? {
        didSet {
            AppSetting.shared.requestCertificate = requestCertificate
        }
    }
    
    var obtainCertificate: ObtainCertificateModel? {
        didSet {
            AppSetting.shared.obtainCertificate = obtainCertificate
        }
    }
    
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
    
    let maximumReconnect = 3
    var numberReconnect = 0
    
    let disposedBag = DisposeBag()
    
    var isEnableReconect: Bool {
        get { numberReconnect < maximumReconnect }
    }
    
    var lostNetworkAfterConnect = false
    
    var loadingRequestCertificate = false
    
    // MARK: INIT
    
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
            selector: #selector(VPNDidFailConfig(notification:)),
            name: Constant.NameNotification.vpnDidFailConfig,
            object: nil
        )
        
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
    
    deinit {
        endBackgroundTask()
    }
    
    // MARK: - FUNCTION - NOTIFICATION
    func configAutoConnect() async {
        checkAutoconnect()
        
        if networkConnectIsCurrentNetwork() && state == .disconnected  {
            await autoConnectWithConfig()
        }
    }
    
    func disconnectCurrentSession() async {
        AppSetting.shared.shouldReconnectVPNIfDropped = false
        connectOrDisconnectByUser = true
        onlyDisconnectWithoutEndsession = true
        await configDisconnect()
        AppSetting.shared.selectAutoConnect = ItemCellType.off.rawValue
        checkAutoconnect()
    }
    
    func checkConnectedVPNLostNetwork() {
        Task {
            if AppSetting.shared.isConnectedToVpn && !Connectivity.sharedInstance.enableNetwork {
                if stateUI == .connected {
                    connectOrDisconnectByUser = true
                    await configDisconnect()
                }
            }
        }
    }
    
    @objc private func autoConnectWithConfig() async {
        if Connectivity.sharedInstance.enableNetwork {
            switch autoConnectType {
            case .always:
                AppSetting.shared.saveBoardTabWhenConnecting(.location)
                await ConnectOrDisconnectVPN()
            case .onWifi:
                if Connectivity.sharedInstance.enableWifi {
                    AppSetting.shared.saveBoardTabWhenConnecting(.location)
                    await ConnectOrDisconnectVPN()
                }
            case .onMobile:
                if Connectivity.sharedInstance.enableCellular {
                    AppSetting.shared.saveBoardTabWhenConnecting(.location)
                    await ConnectOrDisconnectVPN()
                }
            default:
                break
            }
        }
    }
    
    @objc private func VPNDidFailConfig(notification: Notification) {
        errorCallBack?(.apiError(AppAPIError.identified()))
//        if state == .connected {
//            configDisconected()
//            if isEnableReconect, !connectOrDisconnectByUser {
//                Task {
//                    await startConnectVPN(asNewConnection: false)
//                }
//            }
//        } else {
//            configDisconected()
//        }
    }
    
    @MainActor @objc private func VPNDidFail(notification: Notification) {
        print("VPNStatusDidFail: \(notification.vpnError.localizedDescription)")
        guard notification.vpnError.localizedDescription != "permission denied" else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.configDisconected()
            })
            return
        }
        if state == .connected {
            configDisconected()
            if isEnableReconect, !connectOrDisconnectByUser {
                Task {
                    await startConnectVPN(asNewConnection: false)
                }
            }
        } else {
            configDisconected()
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
            if AppSetting.shared.vpnDropped {
                AppSetting.shared.vpnDropped = false
                NotificationCenter.default.post(name: Constant.NameNotification.restoreVPNSuccessfully, object: nil)
            }
            endBackgroundTask()
        case .disconnected:
            configDisconected()
            endBackgroundTask()
//            if AppSetting.shared.shouldReconnectVPNIfDropped {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    AppSetting.shared.shouldReconnectVPNIfDropped = false
//                    Task {
//                        await self.configStartConnectVPN(true)
//                    }
//                }
//            }
        default:
            break
        }
    }
    
    // MARK: - FUNCTION - OTHER
    
    func connectVPNError() {
        connectOrDisconnectByUser = true
        loadingRequestCertificate = false
        state = .disconnected
        stateUI = .disconnected
        errorCallBack?(.apiError(AppAPIError.identified()))
    }
    
    func logoutNeedDisconnect() {
        if state == .connected {
            Task {
                AppSetting.shared.shouldReconnectVPNIfDropped = false
                await configDisconnect()
            }
        }
    }
    
    func changeProtocolSetting() {
        if state == .connected {
            AppSetting.shared.shouldReconnectVPNIfDropped = true
            Task {
                await NetworkManager.shared.configDisconnect()
            }
        }
    }
    
    func connect() async {
        switch getValueConfigProtocol {
        case .openVPNTCP, .openVPNUDP:
            await OpenVPNManager.shared.connect()
        case .wireGuard:
            await WireGuardManager.shared.connect(NetworkManager.shared.obtainCertificate)
        default:
            break
        }
    }
    
    func disconnect() async {
        switch getValueConfigProtocol {
        case .openVPNTCP, .openVPNUDP:
            await OpenVPNManager.shared.disconnect()
        case .wireGuard:
            await WireGuardManager.shared.disconnect()
        default:
            break
        }
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
    
    func ConnectOrDisconnectVPN() async {
        checkAutoconnect()
        switch autoConnectType {
        case .off:
            switch NetworkManager.shared.state {
            case .disconnected:
                AppSetting.shared.saveTimeConnectedVPN = nil
                await configStartConnectVPN()
            case .connecting, .disconnecting:
                configDisconected()
                await configDisconnect()
            default:
                await configDisconnect()
            }
        default:
            if connectOrDisconnectByUser, stateUI != .disconnected {
                if networkConnectIsCurrentNetwork() {
                    errorCallBack?(.autoConnecting)
                } else {
                    await configDisconnect()
                }
            } else {
                switch state {
                case .disconnected:
                    AppSetting.shared.saveTimeConnectedVPN = nil
                    await configStartConnectVPN()
                default:
                    await configDisconnect()
                }
            }
        }
    }
    
    func startConnectVPN(asNewConnection: Bool) async {
        loadingRequestCertificate = true
        await getRequestCertificate(asNewConnection: asNewConnection) {
            if $0 {
                Task {
                    await self.connect()
                }
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
    
    func configDisconnect() async {
        numberReconnect = 0
        await disconnect()
    }
    
    func checkVPN() async {
        if AppSetting.shared.isConnectedToVpn && Connectivity.sharedInstance.enableNetwork {
            if state == .disconnected {
                configConnected()
            }
        } else {
            if state != .disconnected && state != .disconnecting {
                await configDisconnect()
            }
        }
    }
    
    func reconnectVPN() async {
        AppSetting.shared.shouldReconnectVPNIfDropped = true
        Task {
            await NetworkManager.shared.configDisconnect()
        }
    }
    
    func checkVPNKill() async {
        await reconnectVPN()
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
            .subscribe(onSuccess: { response in
                completion(true)
            }, onFailure: { error in
                completion(false)
            })
            .disposed(by: disposedBag)
    }
    
    func configDisconected() {
        DispatchQueue.main.async {
            self.state = .disconnected
            self.stateUI = .disconnected
        }
        if onlyDisconnectWithoutEndsession {
            disconnectSession()
            onlyDisconnectWithoutEndsession = false
        }
        
        AppSetting.shared.lineNetwork = 0
        if connectOrDisconnectByUser {
            AppSetting.shared.currentSessionId = ""
        }
        
        connectOrDisconnectByUser = false
        AppSetting.shared.saveTimeConnectedVPN = nil
        AppSetting.shared.isConnectedToOurVPN = false
    }
    
    func configStartConnectVPN(_ asNewConnection: Bool = true) async {
        beginBackgroundTask()
        if state == .disconnected {
            numberReconnect = 0
            stateUI = .connecting
            await startConnectVPN(asNewConnection: asNewConnection)
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
        endBackgroundTask()
        AppSetting.shared.shouldReconnectVPNIfDropped = true
        AppSetting.shared.isConnectedToOurVPN = true
    }
    
    func getRequestCertificate(asNewConnection: Bool = true, completion: @escaping (Bool) -> Void) async {
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
                            Task {
                                await self.getRequestCertificate(asNewConnection: true) {
                                    completion($0)
                                    return
                                }
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
                            Task {
                                await self.getRequestCertificate(asNewConnection: true) {
                                    completion($0)
                                    return
                                }
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
                        Task {
                            await self.getRequestCertificate(asNewConnection: true) {
                                completion($0)
                                return
                            }
                        }
                    } else {
                        Task {
                            await self.configDisconnect()
                            if response.code == 503 {
                                self.errorCallBack?(.authenNotPremium)
                                completion(false)
                                return
                            }
                            let error = response.errors
                            if !error.isEmpty, let message = error[0] as? String {
                                self.errorCallBack?(.apiError(AppAPIError.identified(message: message)))
                            } else if !response.message.isEmpty {
                                self.errorCallBack?(.apiError(AppAPIError.identified(message: response.message)))
                            }
                            completion(false)
                            return
                        }
                    }
                }
            } onFailure: { error in
                if self.isEnableReconect {
                    Task {
                        await self.getRequestCertificate(asNewConnection: true) {
                            completion($0)
                            return
                        }
                    }
                } else {
                    if let errorConfig = error as? AppAPIError {
                        self.errorCallBack?(.apiError(errorConfig))
                    }
                    completion(false)
                    return
                }
            }
            .disposed(by: disposedBag)
    }
    
    func checkAutoconnect() {
        autoConnectType = ItemCell(type: AppSetting.shared.getAutoConnectProtocol()).type
    }

    func checkIfVPNDropped() async {
//        checkingVPNSerialQueue.async { [weak self] in
//            guard let self = self else { return }
//            if Connectivity.sharedInstance.enableNetwork {
//                Task {
//                    self.beginBackgroundTask()
//                    print("CHECK IF VPN IS DROPPED")
//                    self.state = AppSetting.shared.checkStateConnectedVPN ? .connected : .disconnected
//                    if self.state != .disconnected {
//                        let pingGoogleResult = await self.pingGoogleCheckInternet()
//                        print("PING GOOGLE RESULT = \(pingGoogleResult)")
//                        if !pingGoogleResult {
//                            AppSetting.shared.vpnDropped = true
//                            AppSetting.shared.shouldReconnectVPNIfDropped = true
//                            await self.configDisconnect()
//                        } else {
//                            NotificationCenter.default.post(name: Constant.NameNotification.restoreVPNSuccessfully, object: nil)
//                            self.endBackgroundTask()
//                        }
//                    } else if AppSetting.shared.shouldReconnectVPNIfDropped {
//                        AppSetting.shared.vpnDropped = true
//                        await self.configStartConnectVPN(true)
//                    } else {
//                        NotificationCenter.default.post(name: Constant.NameNotification.restoreVPNSuccessfully, object: nil)
//                        self.endBackgroundTask()
//                    }
//                }
//            }
//        }
    }

    func pingGoogleCheckInternet() async -> Bool {
        await withCheckedContinuation { continuation in
            ServiceManager.shared.ping()
                .subscribe(onSuccess: { response in
                    continuation.resume(returning: true)
                }, onFailure: { error in
                    continuation.resume(returning: false)
                })
                .disposed(by: disposedBag)
        }
    }
}
