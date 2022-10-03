//
//  AppSetting+VPN.swift
//  SysVPN
//
//  Created by Nguyen Dinh Thach on 11/09/2022.
//

import Foundation

extension AppSetting {
    var isAutoConnectEnable: Bool {
        ItemCell(type: AppSetting.shared.getAutoConnectProtocol()).type != .off
    }

    var countryCode: String {
        get {
            return UserDefaults.standard.string(forKey: AppKeys.countryCode.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.countryCode.rawValue)
        }
    }

    var ip: String {
        get {
            return UserDefaults.standard.string(forKey: AppKeys.ip.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.ip.rawValue)
        }
    }

    var cityName: String {
        get {
            return UserDefaults.standard.string(forKey: AppKeys.cityName.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.cityName.rawValue)
        }
    }

    var hasPassword: Bool {
        get {
            return UserDefaults.standard.bool(forKey: AppKeys.hasPassword.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.hasPassword.rawValue)
        }
    }

    var lastChange: Double {
        get {
            return UserDefaults.standard.double(forKey: AppKeys.lastChange.rawValue)
        }
        set {
            updateDataMap = newValue != lastChange
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.lastChange.rawValue)
        }
    }

    var updateDataMap: Bool {
        get {
            return UserDefaults.standard.bool(forKey: AppKeys.updateDataMap.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.updateDataMap.rawValue)
        }
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

    var selectAutoConnect: Int {
        get {
            UserDefaults.standard.integer(forKey: AppKeys.selectAutoConnect.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.selectAutoConnect.rawValue)
        }
    }

    var wasJailBreak: Int {
        get {
            UserDefaults.standard.integer(forKey: AppKeys.wasJailBreak.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.wasJailBreak.rawValue)
        }
    }

    var countryName: String {
        get {
            return UserDefaults.standard.string(forKey: AppKeys.countryName.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.countryName.rawValue)
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
    
    func getRecommendConfigProtocol() -> ItemCellType {
        if let type = ItemCellType(rawValue: AppSetting.shared.recommendConfig) {
            if [.wireGuard, .openVPNTCP, .openVPNUDP].contains(type) {
                return type
            }
            return .openVPNTCP
        }

        return .openVPNTCP
    }
    
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

    func getAutoConnectProtocol() -> ItemCellType {
        if let type = ItemCellType(rawValue: AppSetting.shared.selectAutoConnect) {
            if type != .always && type != .onWifi && type != .onMobile && type != .off {
                return .off
            }
            return type
        }
        return .off
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

    var selectCyberSec: Bool {
        get {
            UserDefaults.standard.bool(forKey: AppKeys.selectCyberSec.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.selectCyberSec.rawValue)
        }
    }
    
    var saveTimeConnectedVPN: Date? {
        get {
            UserDefaults.standard.object(forKey: AppKeys.saveTimeConnectedVPN.rawValue) as? Date
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.saveTimeConnectedVPN.rawValue)
        }
    }
        
    var isConnectedToVpn: Bool {
        if let settings = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? Dictionary<String, Any>,
           let scopes = settings["__SCOPED__"] as? [String:Any] {
            for (key, _) in scopes {
                if key.contains("tap") || key.contains("tun") || key.contains("ppp") || key.contains("ipsec") {
                    return true
                }
            }
        }
        return false
    }

    /// api get ip info in app
    func getIpInfo(completion: @escaping (String?) -> Void) {

        ServiceManager.shared.getAppSettings()
            .subscribe(onSuccess: { [self] response in
                if let result = response.result{
                    configAppSettings(result)
                    completion(nil)
                } else {
                    let error = response.errors
                    if error.count > 0, let message = error[0] as? String {
                        completion(message)
                    } else if !response.message.isEmpty {
                        completion(response.message)
                    }
                    self.getIpInfoOptional { errorOption in
                        completion(errorOption)
                    }
                }
            }, onFailure: { error in
                self.getIpInfoOptional { errorOption in
                    completion(errorOption)
                }
            })
            .disposed(by: disposedBag)
    }

    /// api get ip info optional
    func getIpInfoOptional(completion: @escaping (String?) -> Void) {

        ServiceManager.shared.getIpInfoOptional()
            .subscribe(onSuccess: { [self] response in
                configIpInfo(response)
                completion(nil)
            }, onFailure: { error in
                completion(error.localizedDescription)
            })
            .disposed(by: disposedBag)
    }

    func configIpInfo(_ ipInfo: IpInfoResultModel) {
        AppSetting.shared.ip = ipInfo.ip
        AppSetting.shared.countryCode = ipInfo.countryCode
        AppSetting.shared.countryName = ipInfo.countryName
        AppSetting.shared.cityName = ipInfo.city
        AppSetting.shared.lastChange = ipInfo.lastChange ?? 0
    }

    func configAppSettings(_ result: AppSettingsResultAPI) {
        AppSetting.shared.ip = result.ipInfo.ip
        AppSetting.shared.countryCode = result.ipInfo.countryCode
        AppSetting.shared.countryName = result.ipInfo.countryName
        AppSetting.shared.cityName = result.ipInfo.city
        AppSetting.shared.lastChange = result.lastChange ?? 0

        if let _forceUpdateVersions = result.appSettings?.forceUpdateVersions {
            AppSetting.shared.forceUpdateVersion = _forceUpdateVersions
        }

        if NetworkManager.shared.selectConfig == .recommended {
            if let vpnSetting = result.appSettings?.vpn {
                if vpnSetting.defaultTech == "wg" {
                    NetworkManager.shared.recommendConfig = .wireGuard
                } else if vpnSetting.defaultTech == "openVPN" {
                    if let defaultProtocol = vpnSetting.defaultProtocol {
                        if defaultProtocol == "udp" {
                            NetworkManager.shared.recommendConfig = .openVPNUDP
                        } else {
                            NetworkManager.shared.recommendConfig = .openVPNTCP
                        }
                    }
                }
            }
        }
    }

    func prepareForIpInfo(completion: @escaping (String?) -> Void) {
        if AppSetting.shared.ip == "" {
            AppSetting.shared.getIpInfo { message in
                completion(message)
            }
        }
        completion(nil)
    }

    func fetchListSession() {
        ServiceManager.shared.getListSession()
            .subscribe { response in
                if let result = response.result {
                    AppSetting.shared.currentNumberDevice = result.totalResults
                }
            } onFailure: { error in
            }
            .disposed(by: disposedBag)
    }
}
