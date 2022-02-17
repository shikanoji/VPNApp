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
    
    func login(email: String, password: String) {
        AppSetting.shared.password = password
        AppSetting.shared.email = email
        isValidated = (!AppSetting.shared.password.isEmpty && !AppSetting.shared.email.isEmpty)
    }
    
    func logout() {
        AppSetting.shared.password = ""
        AppSetting.shared.email = ""
        isValidated = (!AppSetting.shared.password.isEmpty && !AppSetting.shared.email.isEmpty)
    }
}
