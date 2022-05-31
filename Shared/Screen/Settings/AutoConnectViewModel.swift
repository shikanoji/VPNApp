//
//  AutoConnectViewModel.swift
//  SysVPN
//
//  Created by Da Phan Van on 26/05/2022.
//

import Foundation

class AutoConnectViewModel: ObservableObject {
    @Published var sectionList: [SectionCell] = [SectionCell(.typeAutoConnect), SectionCell(.autoConnect)]
    
    init() {
        if let type = ItemCellType(rawValue: AppSetting.shared.selectAutoConnect) {
            sectionList = sectionList.map { section in
                var updateSection = section
                updateSection.updateSelectedItemList(ItemCell(type: type, select: true))
                return updateSection
            }
        }
    }
    
    func updateItem(item: ItemCell) {
        sectionList = sectionList.map { section in
            var updateSection = section
            updateSection.updateSelectedItemList(item)
            return updateSection
        }
        
        AppSetting.shared.selectAutoConnect = item.type.rawValue
    }
}
