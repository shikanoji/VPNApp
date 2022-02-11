//
//  DeviceViewModel.swift
//  SysVPN
//
//  Created by Nguyễn Đình Thạch on 08/02/2022.
//

import Foundation
class DeviceViewModel: ObservableObject {
    @Published var deviceList: [DeviceOnline]
    init() {
        deviceList = DeviceOnline.exampleList()
    }
}
