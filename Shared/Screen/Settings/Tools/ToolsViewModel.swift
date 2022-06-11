//
//  ToolsViewModel.swift
//  SysVPN (iOS)
//
//  Created by Nguyen Dinh Thach on 12/05/2022.
//

import Foundation

class ToolsViewModel: ObservableObject {
    @Published var section: SectionCell = .init(.tools)
    
    init() {
        configItem()
    }
    
    func configItem(_ item: ItemCell? = nil) {
        var defaultItem: ItemCell = .init(type: .cyberSec)
        
        if let updateItem = item {
            defaultItem = updateItem
            AppSetting.shared.selectCyberSec = defaultItem.select
        } else {
            defaultItem.select = AppSetting.shared.selectCyberSec
        }
        
        section.updateItem(defaultItem)
    }
}
