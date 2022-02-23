//
//  Authentication.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 21/12/2021.
//

import Foundation
import SwiftUI
import SwiftDate
class Authentication: ObservableObject {
    @Published var isValidated = !(AppSetting.shared.refreshToken.isEmpty || (Date().convertTo(region: .local) > AppSetting.shared.refreshTokenExpires.toDate() ?? Date().convertTo(region: .local)))
    
    func login(email: String, accessToken: Token, refreshToken: Token) {
        AppSetting.shared.email = email
        AppSetting.shared.accessToken = accessToken.token
        AppSetting.shared.accessTokenExpires = accessToken.expires
        AppSetting.shared.refreshToken = refreshToken.token
        AppSetting.shared.refreshTokenExpires = refreshToken.expires
        isValidated = (!AppSetting.shared.refreshToken.isEmpty || !(Date().convertTo(region: .local) > AppSetting.shared.refreshTokenExpires.toDate() ?? Date().convertTo(region: .local)))
    }
    
    func logout() {
        AppSetting.shared.email = ""
        AppSetting.shared.accessToken = ""
        AppSetting.shared.accessTokenExpires = ""
        AppSetting.shared.refreshToken = ""
        AppSetting.shared.refreshTokenExpires = ""
        isValidated = !(AppSetting.shared.refreshToken.isEmpty || (Date().convertTo(region: .local) > AppSetting.shared.refreshTokenExpires.toDate() ?? Date().convertTo(region: .local)))
    }
}
