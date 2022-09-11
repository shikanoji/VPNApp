//
//  AppSetting.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 02/12/2021.
//

import Foundation
import SwiftUI
import SwiftDate
import RxSwift
import Combine

enum AppKeys: String {
    ///Auth Keys
    case idUser = "idUser"
    case email = "email"
    case isPremium = "isPremium"
    case premiumExpires = "premiumExpires"
    case name = "name"
    case accessToken = "accessToken"
    case refreshToken = "refreshToken"
    case accountCreatedTime = "accountCreatedTime"
    case accessTokenExpires = "accessTokenExpires"
    case refreshTokenExpires = "refreshTokenExpires"
    case countryName = "countryName"
    case cityName = "cityName"
    case hasPassword = "hasPassword"
    
    ///Board Keys
    case showedNotice = "showedNotice"
    case dateMember = "dateMember"
    case idVPN = "idVPN"
    case currentNumberDevice = "currentNumberDevice"
    case appShourtcuts = "appShourtcuts"
    case protection = "protection"
    case help = "help"
    case autoConnect = "autoConnect"
    case lineNetwork = "lineNetwork"
    case dataMap = "dataMap"
    case token = "token"
    case countryCode = "countryCode"
    case ip = "ip"
    case listNodeGroup = "listNodeGroup"
    case mutilhopList = "mutilhopList"
    case autoConnectNode = "autoConnectNode"
    case currentTab = "currentTab"
    case nodeSelect = "nodeSelect"
    case staticSelect = "staticSelect"
    case multiSelect = "multiSelect"
    case temporaryDisableAutoConnect = "temporaryDisableAutoConnect"
    case needToStartNewSession = "needToStartNewSession"
    
    ///Last Time when Data Map Update
    case lastChange = "lastChange"
    case updateDataMap = "updateDataMap"
    
    case selectConfig = "selectConfig"
    //DNS
    case dnsSetting = "dnsSetting"
    case primaryDNSValue = "primaryDNSValue"
    case secondaryDNSValue = "secondaryDNSValue"
    case selectAutoConnect = "selectAutoConnect"
    case wasJailBreak = "wasJailBreak"
    
    case currentSessionId = "currentSessionId"
    case selectCyberSec = "selectCyberSec"
}

class AppSetting {
    static var shared = AppSetting()
    var forceUpdateVersion: [String] = []
    @Published var currentNumberDevice: Int = 0
    init() {}
    
    func isExitSearch(_ search: String, name: String, iso2: String, iso3: String) -> Bool {
        return name.range(of: search, options: .caseInsensitive) != nil
        || iso2.range(of: search, options: .caseInsensitive) != nil
        || iso3.range(of: search, options: .caseInsensitive) != nil
    }
    
    var currentSessionId: String {
        get {
            return UserDefaults.standard.string(forKey: AppKeys.currentSessionId.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.currentSessionId.rawValue)
        }
    }
    
    /// Auth Settings
    ///
    var email: String {
        get {
            return UserDefaults.standard.string(forKey: AppKeys.email.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.email.rawValue)
        }
    }
    var idUser: Int {
        get {
            return UserDefaults.standard.integer(forKey: AppKeys.idUser.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.idUser.rawValue)
        }
    }
    
    var isPremium: Bool {
        get {
            return UserDefaults.standard.bool(forKey: AppKeys.isPremium.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.isPremium.rawValue)
        }
    }
    
    var premiumExpires: Int? {
        get {
            return UserDefaults.standard.integer(forKey: AppKeys.premiumExpires.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.premiumExpires.rawValue)
        }
    }
    
    var name: String? {
        get {
            return UserDefaults.standard.string(forKey: AppKeys.name.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.name.rawValue)
        }
    }
    
    var accountCreatedTime: Int? {
        get {
            return UserDefaults.standard.integer(forKey: AppKeys.accountCreatedTime.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.accountCreatedTime.rawValue)
        }
    }
    
    var accessToken: String {
        get {
            return UserDefaults.standard.string(forKey: AppKeys.accessToken.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.accessToken.rawValue)
        }
    }
    
    var refreshToken: String {
        get {
            return UserDefaults.standard.string(forKey: AppKeys.refreshToken.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.refreshToken.rawValue)
        }
    }
    
    var refreshTokenExpires: Int? {
        get {
            return UserDefaults.standard.integer(forKey: AppKeys.refreshTokenExpires.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.refreshTokenExpires.rawValue)
        }
    }
    
    var accessTokenExpires: Int? {
        get {
            return UserDefaults.standard.integer(forKey: AppKeys.accessTokenExpires.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.accessTokenExpires.rawValue)
        }
    }
    
    var showedNotice: Bool {
        get {
            return UserDefaults.standard.bool(forKey: AppKeys.showedNotice.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.showedNotice.rawValue)
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
    
    var selectConfig: Int {
        get {
            UserDefaults.standard.integer(forKey: AppKeys.selectConfig.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.selectConfig.rawValue)
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
            if type != .recommend && type != .wireGuard && type != .openVPNTCP && type != .openVPNUDP {
                return .recommend
            }
            return type
        }
        
        return .recommend
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
    
    var isRefreshTokenValid: Bool {
        guard !refreshToken.isEmpty else {
            return false
        }
        guard let refreshTokenExpiresSeconds = refreshTokenExpires else {
            return false
        }
        let seconds = TimeInterval(refreshTokenExpiresSeconds)
        let expireDate = DateInRegion(seconds: seconds, region: .local)
        return Date().convertTo(region: .local) < expireDate
    }
    
    var isAccessTokenValid: Bool {
        guard !accessToken.isEmpty else {
            return false
        }
        guard let refreshTokenExpiresSeconds = accessTokenExpires else {
            return false
        }
        let seconds = TimeInterval(refreshTokenExpiresSeconds)
        let expireDate = DateInRegion(seconds: seconds, region: .local)
        return Date().convertTo(region: .local) < expireDate
    }
    
    var premiumExpireDate: DateInRegion? {
        guard isPremium, let expireSecond = premiumExpires else {
            return nil
        }
        let expireInteval = TimeInterval(expireSecond)
        let expireDate = DateInRegion(seconds: expireInteval, region: .local)
        return expireDate
    }
    
    var joinedDate: DateInRegion? {
        guard let accountCreatedSecond = accountCreatedTime else {
            return nil
        }
        let accountCreatedTimeInteval = TimeInterval(accountCreatedSecond)
        let joinedDate = DateInRegion(seconds: accountCreatedTimeInteval, region: .local)
        return joinedDate
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
    
    var disposedBag = DisposeBag()
    
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
        
        if NetworkManager.shared.selectConfig == .recommend {
            if let vpnSetting = result.appSettings?.vpn {
                if vpnSetting.defaultTech == "wireguard" {
                    NetworkManager.shared.selectConfig = .wireGuard
                } else if vpnSetting.defaultTech == "openVPN" {
                    if let defaultProtocol = vpnSetting.defaultProtocol {
                        if defaultProtocol == "UDP" {
                            NetworkManager.shared.selectConfig = .openVPNUDP
                        } else {
                            NetworkManager.shared.selectConfig = .openVPNTCP
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
