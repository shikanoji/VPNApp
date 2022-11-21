//
//  AppSetting.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 02/12/2021.
//

import Foundation
import RxSwift

enum AppKeys: String {
    /// Auth Keys
    case idUser = "idUser"
    case email = "email"
    case isPremium = "isPremium"
    case premiumExpires = "premiumExpires"
    case emailVerified = "emailVerified"
    case name = "name"
    case accessToken = "accessToken"
    case refreshToken = "refreshToken"
    case accountCreatedTime = "accountCreatedTime"
    case accessTokenExpires = "accessTokenExpires"
    case refreshTokenExpires = "refreshTokenExpires"
    case countryName = "countryName"
    case cityName = "cityName"
    case hasPassword = "hasPassword"
    case showedNotice = "showedNotice"
    case showedIntroduction = "showedIntroduction"
    case isRefreshingToken = "isRefreshingToken"
    case refreshTokenError = "refreshTokenError"
    case lastTimeSendVerifyEmail = "lastTimeSendVerifyEmail"
    /// Board Keys
    case currentNumberDevice = "currentNumberDevice"
    case help = "help"
    case autoConnect = "autoConnect"
    case lineNetwork = "lineNetwork"
    case dataMap = "dataMap"
    case countryCode = "countryCode"
    case ip = "ip"
    case mutilhopList = "mutilhopList"
    case autoConnectNode = "autoConnectNode"
    case currentTab = "currentTab"
    case boardTabWhenConnecting = "boardTabWhenConnecting"
    case nodeSelect = "nodeSelect"
    case nodeConnecting = "nodeConnecting"
    case staticSelect = "staticSelect"
    case multiSelect = "multiSelect"
    case recommendedCountries = "recommendedCountries"

    /// Last Time when Data Map Update
    case lastChange = "lastChange"
    case updateDataMap = "updateDataMap"

    case selectConfig = "selectConfig"
    case recommendConfig = "recommendConfig"
    // DNS
    case dnsSetting = "dnsSetting"
    case primaryDNSValue = "primaryDNSValue"
    case secondaryDNSValue = "secondaryDNSValue"
    case selectAutoConnect = "selectAutoConnect"
    case wasJailBreak = "wasJailBreak"
    case currentSessionId = "currentSessionId"
    case selectCyberSec = "selectCyberSec"
    // Save time
    case saveTimeConnectedVPN = "saveTimeConnectedVPN"
    case fcmToken = "fcmToken"
    case shouldReconnectVPNIfDropped = "shouldReconnectVPNIfDropped"
    // VPN
    case isConnectedToOurVPN = "isConnectedToOurVPN"
    case vpnDropped = "vpnDropped"
}

class AppSetting {

    static var shared = AppSetting()
    var disposedBag = DisposeBag()
    var forceUpdateVersion: [String] = []
    @Published var currentNumberDevice: Int = 0
    init() {}

    func isExitSearch(_ search: String, name: String, iso2: String, iso3: String) -> Bool {
        return name.range(of: search, options: .caseInsensitive) != nil
            || iso2.range(of: search, options: .caseInsensitive) != nil
            || iso3.range(of: search, options: .caseInsensitive) != nil
    }
}
