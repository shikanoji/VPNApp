//
//  ProtocolSettingViewModel.swift
//  SysVPN
//
//  Created by Da Phan Van on 27/04/2022.
//

import Foundation
import SwiftUI


class ProtocolSettingViewModel: ObservableObject {
    @Published var section: SectionCell = SectionCell(.protocolConnect)
    
    init() {
        configItem()
    }
    
    func configItem(_ item: ItemCell? = nil) {
        var defaultItem: ItemCell?
        
        if let updateItem = item {
            defaultItem = updateItem
        } else {
            defaultItem = ItemCell(type: NetworkManager.shared.selectConfig)
        }
        
        guard let exitItem = defaultItem else {
            return
        }
        
        NetworkManager.shared.selectConfig = exitItem.type

        section.updateSelectedItemListAndUnSelectOther(exitItem)
    }
}
