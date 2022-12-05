//
//  AppSetting+Auth.swift
//  SysVPN
//
//  Created by Nguyen Dinh Thach on 12/09/2022.
//

import Foundation
import SwiftDate

extension AppSetting {
    /// Auth Settings
    ///
    var email: String {
        get {
            return UserDefaults.standard.string(forKey: AppKeys.email.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.email.rawValue)
        }
    }
    var idUser: Int {
        get {
            return UserDefaults.standard.integer(forKey: AppKeys.idUser.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.idUser.rawValue)
        }
    }

    var isPremium: Bool {
        get {
            return UserDefaults.standard.bool(forKey: AppKeys.isPremium.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.isPremium.rawValue)
        }
    }

    var premiumExpires: Int? {
        get {
            return UserDefaults.standard.integer(forKey: AppKeys.premiumExpires.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.premiumExpires.rawValue)
        }
    }

    var name: String? {
        get {
            return UserDefaults.standard.string(forKey: AppKeys.name.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.name.rawValue)
        }
    }

    var accountCreatedTime: Int? {
        get {
            return UserDefaults.standard.integer(forKey: AppKeys.accountCreatedTime.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.accountCreatedTime.rawValue)
        }
    }

    var accessToken: String {
        get {
            return UserDefaults.standard.string(forKey: AppKeys.accessToken.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.accessToken.rawValue)
        }
    }

    var refreshToken: String {
        get {
            return UserDefaults.standard.string(forKey: AppKeys.refreshToken.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.refreshToken.rawValue)
        }
    }

    var refreshTokenExpires: Int? {
        get {
            return UserDefaults.standard.integer(forKey: AppKeys.refreshTokenExpires.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.refreshTokenExpires.rawValue)
        }
    }

    var accessTokenExpires: Int? {
        get {
            return UserDefaults.standard.integer(forKey: AppKeys.accessTokenExpires.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.accessTokenExpires.rawValue)
        }
    }

    var showedNotice: Bool {
        get {
            return UserDefaults.standard.bool(forKey: AppKeys.showedNotice.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.showedNotice.rawValue)
        }
    }

    var showedIntroduction: Bool {
        get {
            return UserDefaults.standard.bool(forKey: AppKeys.showedIntroduction.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.showedIntroduction.rawValue)
        }
    }

    var isRefreshingToken: Bool {
        get {
            return UserDefaults.standard.bool(forKey: AppKeys.isRefreshingToken.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.isRefreshingToken.rawValue)
        }
    }

    var refreshTokenError: Bool {
        get {
            return UserDefaults.standard.bool(forKey: AppKeys.refreshTokenError.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.refreshTokenError.rawValue)
        }
    }

    var emailVerified: Bool {
        get {
            return UserDefaults.standard.bool(forKey: AppKeys.emailVerified.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.emailVerified.rawValue)
        }
    }

    var lastTimeSendVerifyEmail: Int? {
        get {
            return UserDefaults.standard.integer(forKey: AppKeys.lastTimeSendVerifyEmail.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.lastTimeSendVerifyEmail.rawValue)
        }
    }

    var shouldAllowSendVerifyEmail: Bool {
        guard let lastTimeSend = lastTimeSendVerifyEmail else {
            return true
        }
        return (Int(Date().timeIntervalSince1970) - lastTimeSend) > 60 ? true : false
    }

    var isRefreshTokenValid: Bool {
        guard !refreshToken.isEmpty else {
            return false
        }
        guard let refreshTokenExpiresSeconds = refreshTokenExpires else {
            return false
        }
        let seconds = TimeInterval(refreshTokenExpiresSeconds)
        let expireDate = DateInRegion(seconds: seconds, region: .local)
        return Date().convertTo(region: .local) < expireDate
    }

    var isAccessTokenValid: Bool {
        guard !accessToken.isEmpty else {
            return false
        }
        guard let refreshTokenExpiresSeconds = accessTokenExpires else {
            return false
        }
        let seconds = TimeInterval(refreshTokenExpiresSeconds)
        let expireDate = DateInRegion(seconds: seconds, region: .local)
        return Date().convertTo(region: .local) < expireDate
    }

    var premiumExpireDate: DateInRegion? {
        guard isPremium, let expireSecond = premiumExpires else {
            return nil
        }
        let expireInteval = TimeInterval(expireSecond)
        let expireDate = DateInRegion(seconds: expireInteval, region: .local)
        return expireDate
    }

    var joinedDate: DateInRegion? {
        guard let accountCreatedSecond = accountCreatedTime else {
            return nil
        }
        let accountCreatedTimeInteval = TimeInterval(accountCreatedSecond)
        let joinedDate = DateInRegion(seconds: accountCreatedTimeInteval, region: .local)
        return joinedDate
    }
}
