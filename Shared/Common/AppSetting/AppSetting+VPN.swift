//
//  AppSetting+VPN.swift
//  SysVPN
//
//  Created by Nguyen Dinh Thach on 11/09/2022.
//

import Foundation

extension AppSetting {
    var shouldReconnectVPNIfDropped: Bool {
        get {
            return UserDefaults.standard.bool(forKey: AppKeys.shouldReconnectVPNIfDropped.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.shouldReconnectVPNIfDropped.rawValue)
        }
    }

    var fcmToken: String {
        get {
            return UserDefaults.standard.string(forKey: AppKeys.fcmToken.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.fcmToken.rawValue)
        }
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

    var saveTimeConnectedVPN: Date? {
        get {
            UserDefaults.standard.object(forKey: AppKeys.saveTimeConnectedVPN.rawValue) as? Date
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.saveTimeConnectedVPN.rawValue)
        }
    }

    var vpnDropped: Bool {
        get {
            UserDefaults.standard.bool(forKey: AppKeys.vpnDropped.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.vpnDropped.rawValue)
        }
    }

    /// api get ip info in app
    func getIpInfo(completion: @escaping (String?) -> Void) {

        ServiceManager.shared.getAppSettings()
            .subscribe(onSuccess: { [self] response in
                if let result = response.result {
                    configAppSettings(result)
                    completion(nil)
                } else {
                    let error = response.errors
                    if !error.isEmpty, let message = error[0] as? String {
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

    func prepareForIpInfo(completion: @escaping (String?) -> Void) {
//        if AppSetting.shared.ip == "" {
        AppSetting.shared.getIpInfo { message in
            completion(message)
        }
//        }
//        completion(nil)
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
