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
    @Published var isPremium: Bool = AppSetting.shared.isPremium
    @Published var showNoticeAlert: Bool = AppSetting.shared.showedNotice
    
    func login(withLoginData data: LoginResultModel) {
        login(user: data.user, tokens: data.tokens)
    }
    
    func login(withRegisterData data: RegisterResultModel) {
        login(user: data.user, tokens: data.tokens)
    }
    
    private func login(user: User, tokens: Tokens) {
        AppSetting.shared.idUser = Int(user.id)
        AppSetting.shared.email = user.email
        AppSetting.shared.accessToken = tokens.access.token
        AppSetting.shared.accessTokenExpires = tokens.access.expires
        AppSetting.shared.refreshToken = tokens.refresh.token
        AppSetting.shared.refreshTokenExpires = tokens.refresh.expires
        AppSetting.shared.isPremium = user.is_premium
        if user.is_premium {
            Task {
                await AppstoreReceiptHelper.shared.verifyReceipt()
            }
        }
        AppSetting.shared.premiumExpires = user.premium_expire
        AppSetting.shared.name = user.name
        AppSetting.shared.accountCreatedTime = user.created_at
        AppSetting.shared.hasPassword = user.has_password
        isValidated = AppSetting.shared.isRefreshTokenValid
        isPremium = AppSetting.shared.isPremium
        
        AppSetting.shared.loadDataMap = true
    }
    
    func upgradeToPremium(user: User) {
        AppSetting.shared.isPremium = user.is_premium
        AppSetting.shared.premiumExpires = user.premium_expire
        isPremium = AppSetting.shared.isPremium
    }
    
    func logout() {
        ///Should not clear ip, country code and city since it will make user unable to login again unless restarting app
        AppSetting.shared.idUser = 0
        AppSetting.shared.email = ""
        AppSetting.shared.accessToken = ""
        AppSetting.shared.accessTokenExpires = nil
        AppSetting.shared.refreshToken = ""
        AppSetting.shared.refreshTokenExpires = nil
        AppSetting.shared.name = nil
        AppSetting.shared.isPremium = false
        AppSetting.shared.premiumExpires = nil
        AppSetting.shared.accountCreatedTime = nil
        AppSetting.shared.hasPassword = false
        isValidated = AppSetting.shared.isRefreshTokenValid
        isPremium = AppSetting.shared.isPremium
        
        AppSetting.shared.loadDataMap = false
    }
}
