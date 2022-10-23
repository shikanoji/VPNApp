//
//  SettingVPNViewModel.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 03/06/2022.
//

import Foundation

class SettingVPNViewModel: ObservableObject {
    @Published var itemList: [ItemCell] = [
        ItemCell(type: .autoConnect),
        ItemCell(type: .protocolConnect),
        // .split,
        ItemCell(type: .dns),
        // .localNetwork,
        // .metered
    ]
    
    init() {
        refreshItemList()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshItemList),
            name: Constant.NameNotification.checkAutoconnect,
            object: nil
        )
    }
    
    @objc
    func refreshItemList() {
        itemList = [
            ItemCell(type: .autoConnect),
            ItemCell(type: .protocolConnect),
            // .split,
            ItemCell(type: .dns),
            // .localNetwork,
            // .metered
        ]
    }
}
