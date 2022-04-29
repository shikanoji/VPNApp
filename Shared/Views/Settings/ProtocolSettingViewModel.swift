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
    
    func updateItem(_ item: ItemCell) {
        if item.select {
            itemList = itemList.map { item in
                var uncheckItem = item
                uncheckItem.select = false
                return uncheckItem
            }
            
            if let row = itemList.firstIndex(where: {$0.type.title == item.type.title}) {
                itemList[row] = item
            }
            
            switch item.type {
            case .openVPN:
                NetworkManager.shared.selectConfig = .openVPN
            case .wireGuard:
                NetworkManager.shared.selectConfig = .wireguard
            case .recommend:
                NetworkManager.shared.selectConfig = .openVPN
            default:
                break
            }
        }
    }
}
