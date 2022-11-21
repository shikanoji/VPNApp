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
        ItemCell(type: .dns)
    ]

    init() {
        refreshItemList()
    }

    @objc
    func refreshItemList() {
        DispatchQueue.main.async {
            self.itemList = [
                ItemCell(type: .autoConnect),
                ItemCell(type: .protocolConnect),
                ItemCell(type: .dns),
            ]
        }
    }
}
