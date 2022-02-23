//
//  AppSetting.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 02/12/2021.
//

import Foundation
import SwiftUI

enum AppKeys: String {
    ///Auth Keys
    case email = "email"
    case accessToken = "accessToken"
    case refreshToken = "refreshToken"
    case accessTokenExpires = "accessTokenExpires"
    case refreshTokenExpires = "refreshTokenExpires"
    case country = "country"
    case city = "city"
    
    ///Board Keys
    case showedNotice = "showedNotice"
    case dateMember = "dateMember"
    case idVPN = "idVPN"
    case statusAccoutn = "statusAccoutn"
    case currentNumberDevice = "currentNumberDevice"
    case totalNumberDevices = "totalNumberDevices"
    case appShourtcuts = "appShourtcuts"
    case protection = "protection"
    case help = "help"
    case autoConnect = "autoConnect"
    case lineNetwork = "lineNetwork"
    case listNode = "listNode"
    case token = "token"
    case countryCode = "countryCode"
    case ip = "ip"
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
    
    var refreshTokenExpires: String {
        get {
            return UserDefaults.standard.string(forKey: AppKeys.refreshTokenExpires.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.refreshTokenExpires.rawValue)
        }
    }
    
    var accessTokenExpires: String {
        get {
            return UserDefaults.standard.string(forKey: AppKeys.accessTokenExpires.rawValue) ?? ""
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
            return UserDefaults.standard.string(forKey: AppKeys.countryCode.rawValue) ?? "VN"
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.countryCode.rawValue)
        }
    }
    
    var ip: String {
        get {
            return UserDefaults.standard.string(forKey: AppKeys.ip.rawValue) ?? "192.168.1.1"
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.ip.rawValue)
        }
    }
    
    var city: String {
        get {
            return UserDefaults.standard.string(forKey: AppKeys.city.rawValue) ?? "Hanoi"
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.city.rawValue)
        }
    }
}
