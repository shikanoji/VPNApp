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
    
    var temporaryDisableAutoConnect: Bool {
        get {
            return UserDefaults.standard.bool(forKey: AppKeys.temporaryDisableAutoConnect.rawValue) ?? false
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.temporaryDisableAutoConnect.rawValue)
        }
    }

    var needToStartNewSession: Bool {
        get {
            return UserDefaults.standard.bool(forKey: AppKeys.needToStartNewSession.rawValue) ?? false
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.needToStartNewSession.rawValue)
        }
    }
}

extension AppSetting {
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

        func saveAutoConnectNode(_ dataNode: Node?) {
            if dataNode != nil {
                let data = try! JSONEncoder().encode(dataNode!)
                UserDefaults.standard.set(data, forKey: AppKeys.autoConnectNode.rawValue)
            } else {
                UserDefaults.standard.set(nil, forKey: AppKeys.autoConnectNode.rawValue)
            }
        }

        func getAutoConnectNode() -> Node? {
            if let dataAutoConnectNode = UserDefaults.standard.data(forKey: AppKeys.autoConnectNode.rawValue) {
                let autoConnectNode = try! JSONDecoder().decode(Node.self, from: dataAutoConnectNode)
                return autoConnectNode
            }
            return AppSetting.shared.getNodeSelect()
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

        func saveCurrentTab(_ tab: StateTab) {
            UserDefaults.standard.set(tab.rawValue, forKey: AppKeys.currentTab.rawValue)
        }

        func getCurrentTab() -> StateTab {
            let tabIndex = UserDefaults.standard.integer(forKey: AppKeys.currentTab.rawValue)
            let tab = StateTab(rawValue: tabIndex) ?? .location
            return tab
        }

        func saveNodeSelect(_ node: Node) {
            if let encodedData = try? JSONEncoder().encode(node) {
                UserDefaults.standard.set(encodedData, forKey: AppKeys.nodeSelect.rawValue)
            }
        }

        func getNodeSelect() -> Node? {
            if let data = UserDefaults.standard.data(forKey: AppKeys.nodeSelect.rawValue),
               let staticSelect = try? JSONDecoder().decode(Node.self, from: data) {
                return staticSelect
            }
            return nil
        }

        func saveStaticSelect(_ staticSelect: StaticServer) {
            if let encodedData = try? JSONEncoder().encode(staticSelect) {
                UserDefaults.standard.set(encodedData, forKey: AppKeys.staticSelect.rawValue)
            }
        }

        func getStaticSelect() -> StaticServer? {
            if let data = UserDefaults.standard.data(forKey: AppKeys.staticSelect.rawValue),
                let staticSelect = try? JSONDecoder().decode(StaticServer.self, from: data) {
                return staticSelect
            }
            return nil
        }

        func saveMultihopSelect(_ data: MultihopModel) {
            if let encodedData = try? JSONEncoder().encode(data) {
                UserDefaults.standard.set(encodedData, forKey: AppKeys.multiSelect.rawValue)
            }
        }

        func getMultihopSelect() -> MultihopModel? {
            if let data = UserDefaults.standard.data(forKey: AppKeys.multiSelect.rawValue),
               let multihop = try? JSONDecoder().decode(MultihopModel.self, from: data) {
                return multihop
            }
            return nil
        }
}
