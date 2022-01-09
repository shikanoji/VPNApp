//
//  AppSetting.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 02/12/2021.
//

import Foundation
import Foundation

enum AppKeys: String {
    case email = "email"
    case username = "username"
    case password = "password"
    case showedNotice = "showedNotice"
}

struct AppSetting {
    static var shared = AppSetting()
    
    init() {}
    
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
    
    var showedNotice: Bool {
        get {
            return UserDefaults.standard.bool(forKey: AppKeys.showedNotice.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.showedNotice.rawValue)
        }
    }
    
}
