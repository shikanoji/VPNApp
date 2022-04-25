//
//  AppColor.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 09/12/2021.
//

import Foundation
import SwiftUI

struct AppColor {
    static var themeColor = Asset.Colors.darkThemeColor.SuColor
    static var textColor = Color.white
    static var blackText = Asset.Colors.blackText.SuColor
    static var lightBlackText = Asset.Colors.lightBlackText.SuColor
    static var lightBlack = Asset.Colors.lightBlack.SuColor
    static let green = Asset.Colors.green.SuColor
    static var darkButton = Asset.Colors.darkButton.SuColor
    static var background = Asset.Colors.background.SuColor
    static var lightGray = Asset.Colors.lightGray.SuColor
    static let navigationBar = Asset.Colors.navigationBar.SuColor
    
    ///Board
    static let backgroundStatusView = Asset.Colors.backgroundStatusView.SuColor
    static let VPNConnected = Asset.Colors.vpnConnected.SuColor
    static let VPNUnconnect = Asset.Colors.vpnUnconnected.SuColor
    static let backgroundCity = Asset.Colors.backgroundCity.SuColor
    
    static let whiteStatus = Asset.Colors.whiteStatus.SuColor
    static let borderSearch = Asset.Colors.borderSearch.SuColor
    static let greenGradient = Asset.Colors.greenGradient.SuColor
    static let yellowGradient = Asset.Colors.yellowGradient.SuColor
    static let redradient = Asset.Colors.redGradient.SuColor
    
    ///Toast
    static let toastBackground = Asset.Colors.toastBackground.SuColor
    
    ///Loading
    static let rightCircle = Asset.Colors.rightCircle.SuColor
    static let leftCircle = Asset.Colors.leftCircle.SuColor
    static let backgroundLoading = Asset.Colors.backgroundLoading.SuColor
}
