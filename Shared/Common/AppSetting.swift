//
//  AppSetting.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 02/12/2021.
//

import Foundation
import SwiftUI

enum AppKeys: String {
    case email = "email"
    case username = "username"
    case password = "password"
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
}

struct AppSetting {
    static var shared = AppSetting()
    
    init() {}
    
    var email: String {
        get {
            return UserDefaults.standard.string(forKey: AppKeys.email.rawValue) ?? "flashkick2001@gmail.com"
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
            return 4
            return UserDefaults.standard.integer(forKey: AppKeys.lineNetwork.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.lineNetwork.rawValue)
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
