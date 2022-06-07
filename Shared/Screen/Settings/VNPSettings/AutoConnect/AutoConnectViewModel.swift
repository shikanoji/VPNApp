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
        configItem(nil)
    }
    
    func configItem(_ item: ItemCell?) {
        var defaultItem: ItemCell?
        
        if let updateItem = item {
            defaultItem = updateItem
        } else {
            defaultItem = ItemCell(type: AppSetting.shared.getAutoConnectProtocol())
        }
        
        guard let exitItem = defaultItem else {
            return
        }
        
        AppSetting.shared.selectAutoConnect = exitItem.type.rawValue
        sectionList = sectionList.map { section in
            var updateSection = section
            updateSection.updateSelectedItemList(exitItem)
            return updateSection
        }
        NotificationCenter.default.post(name: Constant.NameNotification.checkAutoconnect, object: nil)
    }
}
