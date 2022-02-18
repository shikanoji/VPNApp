//
//  AppSetting+Board.swift
//  SysVPN
//
//  Created by Nguyễn Đình Thạch on 17/02/2022.
//

import Foundation

extension AppSetting {
    /// Board Settings
    var dateMember: Date? {
        get {
            return UserDefaults.standard.object(forKey: AppKeys.dateMember.rawValue) as! Date?
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.dateMember.rawValue)
        }
    }
    
    var idVPN: String {
        get {
            return UserDefaults.standard.string(forKey: AppKeys.idVPN.rawValue) ?? "8966658"
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.dateMember.rawValue)
        }
    }
    
    var statusAccoutn: String {
        get {
            return UserDefaults.standard.string(forKey: AppKeys.statusAccoutn.rawValue) ?? "Premium"
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.statusAccoutn.rawValue)
        }
    }
    
    var currentNumberDevice: Int {
        get {
            return UserDefaults.standard.integer(forKey: AppKeys.currentNumberDevice.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.currentNumberDevice.rawValue)
        }
    }
    
    var totalNumberDevices: Int {
        get {
            return UserDefaults.standard.integer(forKey: AppKeys.totalNumberDevices.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.totalNumberDevices.rawValue)
        }
    }
    
    var appShourtcuts: Bool {
        get {
            return UserDefaults.standard.bool(forKey: AppKeys.appShourtcuts.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.appShourtcuts.rawValue)
        }
    }
    
    var protection: Bool {
        get {
            return UserDefaults.standard.bool(forKey: AppKeys.protection.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.protection.rawValue)
        }
    }
    
    var help: Bool {
        get {
            return UserDefaults.standard.bool(forKey: AppKeys.help.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.help.rawValue)
        }
    }
    
    var autoConnect: Bool {
        get {
            return UserDefaults.standard.bool(forKey: AppKeys.autoConnect.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.autoConnect.rawValue)
        }
    }
    
    var lineNetwork: Int {
        get {
            return UserDefaults.standard.integer(forKey: AppKeys.lineNetwork.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.lineNetwork.rawValue)
        }
    }
    
    var token: String {
        get {
            return UserDefaults.standard.string(forKey: AppKeys.token.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.token.rawValue)
        }
    }
    
    func getDateMemberSince() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        
        if let date = dateMember {
            return dateFormatter.string(from: date)
        } else {
            return "2023-10-27 15:30 GMT+1"
        }
    }
    
//    var listNode: [Node] {
//        get {
//            return UserDefaults.standard.value(forKey: AppKeys.listNode.rawValue)
//        }
//        set {
//
//        }
//    }
}
