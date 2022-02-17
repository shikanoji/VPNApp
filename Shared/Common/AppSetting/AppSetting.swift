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
    case username = "username"
    case password = "password"
    case accessToken = "accessToken"
    case refreshToken = "refreshToken"
    
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
    
    var username: String {
        get {
            return UserDefaults.standard.string(forKey: AppKeys.username.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.username.rawValue)
        }
    }
    
    var password: String {
        get {
            return UserDefaults.standard.string(forKey: AppKeys.password.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.password.rawValue)
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
    
    var showedNotice: Bool {
        get {
            return UserDefaults.standard.bool(forKey: AppKeys.showedNotice.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.showedNotice.rawValue)
        }
    }
}
