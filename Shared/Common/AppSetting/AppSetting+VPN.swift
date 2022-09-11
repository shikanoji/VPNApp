//
//  AppSetting+VPN.swift
//  SysVPN
//
//  Created by Nguyen Dinh Thach on 11/09/2022.
//

import Foundation
extension AppSetting {
    var isAutoConnectEnable: Bool {
        ItemCell(type: AppSetting.shared.getAutoConnectProtocol()).type != .off
    }
}
