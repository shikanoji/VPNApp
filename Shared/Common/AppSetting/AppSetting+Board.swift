//
//  AppSetting+Board.swift
//  SysVPN
//
//  Created by Nguyễn Đình Thạch on 17/02/2022.
//

import Foundation
import SwiftUI

extension AppSetting {
    /// Board Settings
    
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
    
    func getLocationMap() -> CGPoint {
        guard let clientCountryNode = AppSetting.shared.getDataMap()?.clientCountryDetail else {
            return .init(
                x: Constant.Board.Map.widthScreen / 2,
                y: Constant.Board.Map.heightScreen / 2
            )
        }
        
        return .init(x: clientCountryNode.x, y: clientCountryNode.y)
    }
}

extension AppSetting {
    
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
    
    func getAutoConnectNodeToConnect() -> Node? {
        if let fastestServer = getAutoConnectNode() {
            return fastestServer
        }
        
        return AppSetting.shared.getRecommendedCountries().first
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
    
    func saveBoardTabWhenConnecting(_ tab: StateTab) {
        UserDefaults.standard.set(tab.rawValue, forKey: AppKeys.boardTabWhenConnecting.rawValue)
    }
    
    func getBoardTabWhenConnecting() -> StateTab {
        let tabIndex = UserDefaults.standard.integer(forKey: AppKeys.boardTabWhenConnecting.rawValue)
        let tab = StateTab(rawValue: tabIndex) ?? .location
        return tab
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
    
    func saveNodeConnecting(_ data: Node) {
        if let encodedData = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encodedData, forKey: AppKeys.nodeConnecting.rawValue)
        }
    }
    
    func getNodeConnecting() -> Node? {
        if let data = UserDefaults.standard.data(forKey: AppKeys.nodeConnecting.rawValue),
           let node = try? JSONDecoder().decode(Node.self, from: data) {
            return node
        }
        return nil
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
    
    func saveRecommendedCountries(_ data: [Node]) {
        if let encodedData = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encodedData, forKey: AppKeys.recommendedCountries.rawValue)
        }
    }
    
    func getRecommendedCountries() -> [Node] {
        if let data = UserDefaults.standard.data(forKey: AppKeys.recommendedCountries.rawValue),
           let nodeList = try? JSONDecoder().decode([Node].self, from: data) {
            return nodeList
        }
        return []
    }
}
