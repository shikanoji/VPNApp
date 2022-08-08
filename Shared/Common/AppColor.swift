//
//  AppColor.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 09/12/2021.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct AppColor {
    static let planSelectSave = Color(hex: "#FFE766")
    
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
