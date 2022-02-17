//
//  Authentication.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 21/12/2021.
//

import Foundation
import SwiftUI
class Authentication: ObservableObject {
    @Published var isValidated = (!AppSetting.shared.password.isEmpty && !AppSetting.shared.email.isEmpty)
    
    func login(email: String, password: String, accessToken: String, refreshToken: String) {
        AppSetting.shared.password = password
        AppSetting.shared.email = email
        AppSetting.shared.accessToken = accessToken
        AppSetting.shared.refreshToken = refreshToken
        isValidated = (!AppSetting.shared.password.isEmpty && !AppSetting.shared.email.isEmpty)
    }
    
    func logout() {
        AppSetting.shared.password = ""
        AppSetting.shared.email = ""
        AppSetting.shared.accessToken = ""
        AppSetting.shared.refreshToken = ""
        isValidated = (!AppSetting.shared.password.isEmpty && !AppSetting.shared.email.isEmpty)
    }
}
