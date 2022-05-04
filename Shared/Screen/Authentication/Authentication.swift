//
//  Authentication.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 21/12/2021.
//

import Foundation
import SwiftUI

class Authentication: ObservableObject {
    @Published var isValidated: Bool = AppSetting.shared.isRefreshTokenValid
    
    func login(withLoginData data: LoginResultModel) {
        AppSetting.shared.email = data.user.email
        AppSetting.shared.accessToken = data.tokens.access.token
        AppSetting.shared.accessTokenExpires = data.tokens.access.expires
        AppSetting.shared.refreshToken = data.tokens.refresh.token
        AppSetting.shared.refreshTokenExpires = data.tokens.refresh.expires
        AppSetting.shared.isPremium = data.user.is_premium
        AppSetting.shared.premiumExpires = data.user.premium_expire
        AppSetting.shared.name = data.user.name
        isValidated = AppSetting.shared.isRefreshTokenValid
    }
    
    func login(withRegisterData data: RegisterResultModel) {
        AppSetting.shared.email = data.user.email
        AppSetting.shared.accessToken = data.tokens.access.token
        AppSetting.shared.accessTokenExpires = data.tokens.access.expires
        AppSetting.shared.refreshToken = data.tokens.refresh.token
        AppSetting.shared.refreshTokenExpires = data.tokens.refresh.expires
        AppSetting.shared.isPremium = data.user.is_premium
        AppSetting.shared.premiumExpires = data.user.premium_expire
        AppSetting.shared.name = data.user.name
        isValidated = AppSetting.shared.isRefreshTokenValid
    }
    
    func logout() {
        ///Should not clear ip, country code and city since it will make user unable to login again unless restarting app
        AppSetting.shared.email = ""
        AppSetting.shared.accessToken = ""
        AppSetting.shared.accessTokenExpires = nil
        AppSetting.shared.refreshToken = ""
        AppSetting.shared.refreshTokenExpires = nil
        AppSetting.shared.name = nil
        AppSetting.shared.isPremium = false
        AppSetting.shared.premiumExpires = nil
        isValidated = AppSetting.shared.isRefreshTokenValid
    }
}
