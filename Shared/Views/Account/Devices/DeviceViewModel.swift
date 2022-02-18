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
    
    func remove(device: DeviceOnline) {
        if deviceList.count > 0 {
            for i in 0..<deviceList.count {
                if deviceList[i].id == device.id {
                    deviceList.remove(at: i)
                    return 
                }
            }
        }
    }
    
    func getDeviceCellPosition(device: DeviceOnline) -> PositionItemCell {
        if deviceList.count > 0 {
            for i in 0..<deviceList.count {
                if deviceList[i].id == device.id {
                    return deviceList.getPosition(i)
                }
            }
        }
        return .all
    }
}
