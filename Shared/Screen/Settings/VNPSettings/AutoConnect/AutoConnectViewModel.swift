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
        configItem()
    }

    func configItem(_ item: ItemCell = ItemCell(type: AppSetting.shared.getAutoConnectProtocol())) {
        AppSetting.shared.selectAutoConnect = item.type.rawValue
        DispatchQueue.main.async {
            self.sectionList = self.sectionList.map { section in
                if section.type == .autoConnect {
                    return SectionCell(.autoConnect)
                }
                var updateSection = section
                updateSection.updateSelectedItemListAndUnSelectOther(item)
                Task {
                    await NetworkManager.shared.configAutoConnect()
                }
                return updateSection
            }
        }
    }
}
