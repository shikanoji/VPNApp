//
//  Authentication.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 21/12/2021.
//

import Foundation
import SwiftUI
class Authentication: ObservableObject {
    @Published var isValidated = (!AppSetting.shared.password.isEmpty && !AppSetting.shared.username.isEmpty)
    
    func login(username: String, password: String) {
        AppSetting.shared.password = password
        AppSetting.shared.username = username
        isValidated = (!AppSetting.shared.password.isEmpty && !AppSetting.shared.username.isEmpty)
    }
    
    func logout() {
        AppSetting.shared.password = ""
        AppSetting.shared.username = ""
        isValidated = (!AppSetting.shared.password.isEmpty && !AppSetting.shared.username.isEmpty)
    }
}
