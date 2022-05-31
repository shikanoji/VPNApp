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
    case email = "email"
    case isPremium = "isPremium"
    case premiumExpires = "premiumExpires"
    case name = "name"
    case accessToken = "accessToken"
    case refreshToken = "refreshToken"
    case accountCreatedTime = "accountCreatedTime"
    case accessTokenExpires = "accessTokenExpires"
    case refreshTokenExpires = "refreshTokenExpires"
    case country = "country"
    case city = "city"
    
    ///Board Keys
    case showedNotice = "showedNotice"
    case dateMember = "dateMember"
    case idVPN = "idVPN"
    case currentNumberDevice = "currentNumberDevice"
    case totalNumberDevices = "totalNumberDevices"
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
    case customDNSValue = "customDNSValue"
}

struct AppSetting {
    static var shared = AppSetting()
    
    init() {}
    
    /// Auth Settings
    var email: String {
        get {
            return UserDefaults.standard.string(forKey: AppKeys.email.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.email.rawValue)
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
    
    var city: String {
        get {
            /// Fake City
            return "Hanoi"
            return UserDefaults.standard.string(forKey: AppKeys.city.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.city.rawValue)
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
    
    var customDNSValue: String {
        get {
            UserDefaults.standard.string(forKey: AppKeys.customDNSValue.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.customDNSValue.rawValue)
        }
    }
}
