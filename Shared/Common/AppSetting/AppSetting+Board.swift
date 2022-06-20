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
    
    var currentNumberDevice: Int {
        get {
            return UserDefaults.standard.integer(forKey: AppKeys.currentNumberDevice.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.currentNumberDevice.rawValue)
        }
    }
    
    var maxNumberDevices: Int {
        get {
            return 6
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
    
    func saveDataMap(_ dataMap: CountryListResultModel) {
        let data = try! JSONEncoder().encode(dataMap )
        UserDefaults.standard.set(data, forKey: AppKeys.dataMap.rawValue)
    }
    
    func getDataMap() -> CountryListResultModel? {
        if let dataMapData = UserDefaults.standard.data(forKey: AppKeys.dataMap.rawValue) {
            let dataMap = try! JSONDecoder().decode(CountryListResultModel.self, from: dataMapData)
            return dataMap
        }
        return nil
    }
    
    func saveMutilhopList(_ arr: [MultihopModel]) {
        let data = try! JSONEncoder().encode(arr)
        UserDefaults.standard.set(data, forKey: AppKeys.mutilhopList.rawValue)
    }
    
    func getMutilhopList() -> [MultihopModel]? {
        if let mutilhopListData = UserDefaults.standard.data(forKey: AppKeys.mutilhopList.rawValue) {
            let mutilhopList = try! JSONDecoder().decode([MultihopModel].self, from: mutilhopListData)
            return mutilhopList
        }
        return nil
    }
}
