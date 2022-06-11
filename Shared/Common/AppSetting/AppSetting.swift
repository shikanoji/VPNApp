//
//  AppSetting.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 02/12/2021.
//

import Foundation
import SwiftUI
import SwiftDate

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

struct AppSetting {
    static var shared = AppSetting()
    
    init() {}
    
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
            if type != .recommend && type != .wireGuard && type != .openVPN {
                return .recommend
            }
            return type
        }
        
        return .recommend
    }
    
    func getAutoConnectProtocol() -> ItemCellType {
        if let type = ItemCellType(rawValue: AppSetting.shared.selectAutoConnect) {
            if type != .always && type != .onWifi && type != .onMobile && type != .off {
                return .recommend
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
}
