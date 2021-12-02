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
    case password = "password"
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
    
    var password: String {
        get {
            return UserDefaults.standard.string(forKey: AppKeys.password.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.password.rawValue)
        }
    }
    
    
}
