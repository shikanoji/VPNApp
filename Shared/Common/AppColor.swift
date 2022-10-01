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
    static let disconectStateView = Asset.Colors.lightBlack.swiftUIColor
    static let connectedStateView = Color(hex: "#216E5A")
    static let planSelectSave = Color(hex: "#FFE766")
    
    static var themeColor = Asset.Colors.darkThemeColor.swiftUIColor
    static var textColor = Color.white
    static var blackText = Asset.Colors.blackText.swiftUIColor
    static var lightBlackText = Asset.Colors.lightBlackText.swiftUIColor
    static var lightBlack = Asset.Colors.lightBlack.swiftUIColor
    static let green = Asset.Colors.green.swiftUIColor
    static var darkButton = Asset.Colors.darkButton.swiftUIColor
    static var background = Asset.Colors.background.swiftUIColor
    static var lightGray = Asset.Colors.lightGray.swiftUIColor
    static let navigationBar = Asset.Colors.navigationBar.swiftUIColor
    
    ///Board
    static let backgroundStatusView = Asset.Colors.backgroundStatusView.swiftUIColor
    static let VPNConnected = Asset.Colors.vpnConnected.swiftUIColor
    static let VPNUnconnect = Asset.Colors.vpnUnconnected.swiftUIColor
    static let backgroundCity = Asset.Colors.backgroundCity.swiftUIColor
    static let gradientEntry = Asset.Colors.gradientEntry.swiftUIColor
    static let gradientExit = Asset.Colors.gradientExit.swiftUIColor
    
    static let whiteStatus = Asset.Colors.whiteStatus.swiftUIColor
    static let borderSearch = Asset.Colors.borderSearch.swiftUIColor
    static let greenGradient = Asset.Colors.greenGradient.swiftUIColor
    static let yellowGradient = Asset.Colors.yellowGradient.swiftUIColor
    static let redradient = Asset.Colors.redGradient.swiftUIColor
    
    ///Toast
    static let toastBackground = Asset.Colors.toastBackground.swiftUIColor
    
    ///Loading
    static let rightCircle = Asset.Colors.rightCircle.swiftUIColor
    static let leftCircle = Asset.Colors.leftCircle.swiftUIColor
    static let backgroundLoading = Asset.Colors.backgroundLoading.swiftUIColor
    
    static let grayBackground = Asset.Colors.grayCenterBackground.swiftUIColor
    
    static let freeTrial = Asset.Colors.freeTrial.swiftUIColor
}
