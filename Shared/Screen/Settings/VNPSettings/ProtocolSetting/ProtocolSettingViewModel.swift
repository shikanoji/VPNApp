//
//  ProtocolSettingViewModel.swift
//  SysVPN
//
//  Created by Da Phan Van on 27/04/2022.
//

import Foundation
import SwiftUI


class ProtocolSettingViewModel: ObservableObject {
    
    @Published var itemList: [ItemCell] = SectionType.protocolConnect.items
    
    init() {
        refreshItem()
    }
    
    func refreshItem() {
        itemList = itemList.map { item in
            let selectConfig = NetworkManager.shared.selectConfig
            var updateItem = item
            switch item.type {
            case .recommend:
                if selectConfig == .recommend {
                    updateItem.select = true
                }
            case .openVPN:
                if selectConfig == .openVPN {
                    updateItem.select = true
                }
            case .wireGuard:
                if selectConfig == .wireGuard {
                    updateItem.select = true
                }
            default:
                break
            }
            return updateItem
        }
    }
    
    func updateItem(_ item: ItemCell) {
        if item.select {
            itemList = itemList.map { item in
                var uncheckItem = item
                uncheckItem.select = false
                return uncheckItem
            }
            
            if let row = itemList.firstIndex(where: {$0.type == item.type}) {
                itemList[row] = item
            }
            
            switch item.type {
            case .openVPN:
                NetworkManager.shared.selectConfig = .openVPN
            case .wireGuard:
                NetworkManager.shared.selectConfig = .wireGuard
            case .recommend:
                NetworkManager.shared.selectConfig = .recommend
            default:
                break
            }
        }
    }
}
