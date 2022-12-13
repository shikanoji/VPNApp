//
//  AppSetting.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 02/12/2021.
//

import Foundation
import RxSwift

enum AppKeys: String {
    /// Auth Keys
    case changeDomain = "changeDomain"
    case idUser = "idUser"
    case email = "email"
    case isPremium = "isPremium"
    case premiumExpires = "premiumExpires"
    case emailVerified = "emailVerified"
    case name = "name"
    case accessToken = "accessToken"
    case refreshToken = "refreshToken"
    case accountCreatedTime = "accountCreatedTime"
    case accessTokenExpires = "accessTokenExpires"
    case refreshTokenExpires = "refreshTokenExpires"
    case countryName = "countryName"
    case cityName = "cityName"
    case hasPassword = "hasPassword"
    case showedNotice = "showedNotice"
    case showedIntroduction = "showedIntroduction"
    case isRefreshingToken = "isRefreshingToken"
    case refreshTokenError = "refreshTokenError"
    case lastTimeSendVerifyEmail = "lastTimeSendVerifyEmail"
    /// Board Keys
    case currentNumberDevice = "currentNumberDevice"
    case help = "help"
    case autoConnect = "autoConnect"
    case lineNetwork = "lineNetwork"
    case dataMap = "dataMap"
    case countryCode = "countryCode"
    case ip = "ip"
    case mutilhopList = "mutilhopList"
    case autoConnectNode = "autoConnectNode"
    case currentTab = "currentTab"
    case boardTabWhenConnecting = "boardTabWhenConnecting"
    case nodeSelect = "nodeSelect"
    case nodeConnecting = "nodeConnecting"
    case staticSelect = "staticSelect"
    case multiSelect = "multiSelect"
    case recommendedCountries = "recommendedCountries"

    /// Last Time when Data Map Update
    case lastChange = "lastChange"
    case updateDataMap = "updateDataMap"

    case selectConfig = "selectConfig"
    case recommendConfig = "recommendConfig"
    // DNS
    case dnsSetting = "dnsSetting"
    case primaryDNSValue = "primaryDNSValue"
    case secondaryDNSValue = "secondaryDNSValue"
    case selectAutoConnect = "selectAutoConnect"
    case wasJailBreak = "wasJailBreak"
    case currentSessionId = "currentSessionId"
    case selectCyberSec = "selectCyberSec"
    // Save time
    case saveTimeConnectedVPN = "saveTimeConnectedVPN"
    case fcmToken = "fcmToken"
    case shouldReconnectVPNIfDropped = "shouldReconnectVPNIfDropped"
    // VPN
    case isConnectedToOurVPN = "isConnectedToOurVPN"
    case vpnDropped = "vpnDropped"

    case paramGetCert = "paramGetCert"
    case headerGetCert = "headerGetCert"
}

class AppSetting {

    var paramGetCert: [String: Any] {
        get {
            UserDefaults.standard.object(forKey: AppKeys.paramGetCert.rawValue) as! [String : Any]
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.paramGetCert.rawValue)
        }
    }

    var headerGetCert: [String: String] {
        get {
            UserDefaults.standard.object(forKey: AppKeys.headerGetCert.rawValue) as! [String : String]
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.headerGetCert.rawValue)
        }
    }

    static var shared = AppSetting()
    var disposedBag = DisposeBag()
    var forceUpdateVersion: [String] = []
    @Published var currentNumberDevice: Int = 0
    var requestCertificate: RequestCertificateModel?

    var obtainCertificate: ObtainCertificateModel?
    init() {}

    func getValueConfigProtocol() -> ItemCellType {
        if let type = ItemCellType(rawValue: AppSetting.shared.selectConfig) {
            if [.wireGuard, .openVPNTCP, .openVPNUDP].contains(type) {
                return type
            }
            if type == .recommended {
                return getRecommendConfigProtocol()
            }
        }
        return .openVPNTCP
    }

    func getRecommendConfigProtocol() -> ItemCellType {
        if let type = ItemCellType(rawValue: AppSetting.shared.recommendConfig) {
            if [.wireGuard, .openVPNTCP, .openVPNUDP].contains(type) {
                return type
            }
            return .openVPNTCP
        }

        return .openVPNTCP
    }

    func isExitSearch(_ search: String, name: String, iso2: String, iso3: String) -> Bool {
        return name.range(of: search, options: .caseInsensitive) != nil
            || iso2.range(of: search, options: .caseInsensitive) != nil
            || iso3.range(of: search, options: .caseInsensitive) != nil
    }

    var selectCyberSec: Bool {
        get {
            UserDefaults.standard.bool(forKey: AppKeys.selectCyberSec.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.selectCyberSec.rawValue)
        }
    }

    var dnsSetting: DNSSetting {
        get {
            guard let settingString = UserDefaults.standard.string(forKey: AppKeys.dnsSetting.rawValue) else {
                return .system
            }
            return DNSSetting(rawValue: settingString) ?? .custom
        }
        set {
            UserDefaults.standard.setValue(newValue.rawValue, forKey: AppKeys.dnsSetting.rawValue)
        }
    }

    var primaryDNSValue: String {
        get {
            UserDefaults.standard.string(forKey: AppKeys.primaryDNSValue.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.primaryDNSValue.rawValue)
        }
    }

    var secondaryDNSValue: String {
        get {
            UserDefaults.standard.string(forKey: AppKeys.secondaryDNSValue.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.secondaryDNSValue.rawValue)
        }
    }

    func getContentDNSCell() -> String {
        var defaultContent = L10n.Settings.Dns.default
        if dnsSetting == .custom {
            if primaryDNSValue != "" {
                defaultContent = primaryDNSValue
            }
            if secondaryDNSValue != "" {
                defaultContent = ", " + secondaryDNSValue
            }
        }
        return defaultContent
    }

    var selectAutoConnect: Int {
        get {
            UserDefaults.standard.integer(forKey: AppKeys.selectAutoConnect.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.selectAutoConnect.rawValue)
        }
    }

    func getAutoConnectProtocol() -> ItemCellType {
        if let type = ItemCellType(rawValue: AppSetting.shared.selectAutoConnect) {
            if type != .always && type != .onWifi && type != .onMobile && type != .off {
                return .off
            }
            return type
        }
        return .off
    }

    var help: Bool {
        get {
            return UserDefaults.standard.bool(forKey: AppKeys.help.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.help.rawValue)
        }
    }

    var maxNumberDevices: Int {
        get {
            return 6
        }
    }

    func getAutoConnectNode() -> Node? {
        if let dataAutoConnectNode = UserDefaults.standard.data(forKey: AppKeys.autoConnectNode.rawValue) {
            let autoConnectNode = try! JSONDecoder().decode(Node.self, from: dataAutoConnectNode)
            return autoConnectNode
        }
        return nil
    }

    var selectConfig: Int {
        get {
            UserDefaults.standard.integer(forKey: AppKeys.selectConfig.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.selectConfig.rawValue)
        }
    }

    var recommendConfig: Int {
        get {
            UserDefaults.standard.integer(forKey: AppKeys.recommendConfig.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.recommendConfig.rawValue)
        }
    }

    func getConfigProtocol() -> ItemCellType {
        if let type = ItemCellType(rawValue: AppSetting.shared.selectConfig) {
            if [.wireGuard, .openVPNTCP, .openVPNUDP].contains(type) {
                return type
            }
            if type == .recommended {
                return .recommended
            }
        }

        return .recommended
    }

    var needLoadApiMap: Bool {
        if Date().timeIntervalSince1970 >= UserDefaults.standard.double(forKey: AppKeys.lastChange.rawValue) {
            return true
        } else {
            return false
        }
    }

    var currentSessionId: String {
        get {
            return UserDefaults.standard.string(forKey: AppKeys.currentSessionId.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.currentSessionId.rawValue)
        }
    }

    var isConnectedToOurVPN: Bool {
        get {
            UserDefaults.standard.bool(forKey: AppKeys.isConnectedToOurVPN.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.isConnectedToOurVPN.rawValue)
        }
    }

    var isConnectedToVpn: Bool {
        if let settings = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? Dictionary<String, Any>,
           let scopes = settings["__SCOPED__"] as? [String:Any] {
            for (key, _) in scopes {
                if key.contains("tap") || key.contains("tun") || key.contains("ppp") || key.contains("ipsec") || key.contains("ipsec0") || key.contains("utun1") || key.contains("utun2") {
                    return true
                }
            }
        }
        return false
    }

    var checkStateConnectedVPN: Bool {
        return isConnectedToOurVPN && isConnectedToVpn
    }

    var shouldReconnectVPNIfDropped: Bool {
        get {
            return UserDefaults.standard.bool(forKey: AppKeys.shouldReconnectVPNIfDropped.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.shouldReconnectVPNIfDropped.rawValue)
        }
    }

    var openVPNTunnelCouldBeDropped: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "openVPNTunnelCouldBeDropped")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "openVPNTunnelCouldBeDropped")
        }
    }
}
