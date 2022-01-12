//
//  Constant.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 02/12/2021.
//

import Foundation
import UIKit
import SwiftUI

struct Constant {
    struct api {
        static let root = "google.com.vn"
        static let getLocationCity = "google.com.vn"
    }
    
    struct Board {
        struct Image {
            static let setting = "icon_setting_board"
            static let user = "icon_user_board"
            static let locationDefault = "icon_location_default_board"
            static let connected = "icon_connected_board"
            static let uploadSpeed = "icon_board_up_speed"
            static let downloadSpeed = "icon_board_down_speed"
        }
        
        struct SubBoard {
            static let radius: CGFloat = 8
            static let height: CGFloat = 60
            static let fontSize: CGFloat = 12
            static let fontColor: Color = .white
            static let weightFont: Font.Weight = .medium
            static let weightFontStatus: Font.Weight = .semibold
        }
        
        struct IconFrame {
            static let leftIconWidth: CGFloat = 30
            static let rightIconWidth: CGFloat = 30
        }
        
        struct Navigation {
            static let heightNavigationBar: CGFloat = 60
            static let sizeFont: CGFloat = 14
            static let weightFont: Font.Weight = .bold
        }
        
        struct QuickButton {
            static let widthSize: CGFloat = 95
            static let heightSize: CGFloat = 135
            static let widthBorderMax: CGFloat = 5
            static let sizeDoc: CGFloat = 8
        }
        
        struct Alert {
            static let sizeFont: CGFloat = 12
            static let weightFont: Font.Weight = .semibold
        }
        
        struct Tabs {
            static let heightSize: CGFloat = 40
            static let topPadding: CGFloat = 50
        }
        
        struct Speed {
            static let heightIcon: CGFloat = 20
        }
        
        struct NodePopupView {
            static let sizeFont: CGFloat = 8
            static let weightFont: Font.Weight = .semibold
            static let paddingContent: CGFloat = 3.0
            static let frameEnsign: CGFloat = 10.0
            static let widthTriangle: CGFloat = 12
            static let heightTriangle: CGFloat = 5
            static let backgroudTriangle: Color = .white
            static let cornerRadius: CGFloat = 5
            static let numberLineText = 1
            static let heightContentPopupView: CGFloat = 40
        }
        
        struct Map {
            static let minZoom: CGFloat = 1
            static let maxZoom: CGFloat = 5
            static let enableCityZoom: CGFloat = 2
            static let zoomCity: CGFloat = 0.75
        }
    }
}
