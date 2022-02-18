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
            static let minZoom: CGFloat = 0.1
            static let maxZoom: CGFloat = 4
            static let enableCityZoom: CGFloat = 3
            static let zoomCity: CGFloat = 0.75
        }
    }
    
    struct Account {
        static let iconProfile = "icon_setting_profile"
        static let heightIconProfile: CGFloat = 40
        static let heightCellProfile: CGFloat = 84
        static let fontEmail: Font = Font.system(size: 14, weight: .bold)
        static let fontSubEmail: Font = Font.system(size: 12)
        static let colorProfile: Color = .white
        static let rightButton = "icon_setting_item_right"
        static let iconRemove = "icon_remove"
        static let fontRightNavigation = Font.system(size: 11, weight: .bold)
    }
    
    struct CustomNavigation {
        static let iconBack = "icon_setting_back"
        static let iconLeft = "icon_setting_item_left"
        static let iconRightConnect = "icon_setting_right_connect"
        static let heightCurrentTitle: CGFloat = 38
        static let fontTitleNavigation = Font.system(size: 20, weight: .semibold)
    }
    
    struct Menu {
        static let fontSubItem = Font.system(size: 11, weight: .regular)
        static let fontSectionTitle = Font.system(size: 12, weight: .medium)
        static let sizeIconItemMenu: CGFloat = 32
        static let fontItem = Font.system(size: 13, weight: .bold)
        static let heightItemMenu: CGFloat = 48
        static let radiusCell: CGFloat = 10
        static let heightItemCell: CGFloat = 63
        static let hozitalPaddingCell: CGFloat = 16
        static let topPaddingCell: CGFloat = 15
    }
    
    struct ChangePassWord {
        static let fontTitle = Font.system(size: 16, weight: .bold)
        static let fontSubContent = Font.system(size: 14, weight: .regular)
    }
    
    struct BoardList {
        static let iconUp = "icon_setting_item_up"
        static let fontLocationStatus = Font.system(size: 14, weight: .bold)
        static let heightStatusLoction: CGFloat = 50
        static let heightSearchLoction: CGFloat = 48
        static let heightImageNode: CGFloat = 32
        static let fontNameCity = Font.system(size: 13, weight: .bold)
        static let numberCities = Font.system(size: 11, weight: .bold)
        static let fontNodeList = Font.system(size: 12)
        static let iconCity = Image("icon_board_city")
    }
    
    struct StaticIP {
        static let iconS = Image("icon_static")
    }
    
    struct MultiHop {
        static let iconWhat = Image("icon_multihop_what")
        static let iconExit = Image("icon_multihop_exit")
        static let sizeIcon: CGFloat = 24
    }
    
    struct Global {
        static let errorImage = Image("japan")
        static let iconCheck = Image("icon_checkbox")
        static let iconUncheck = Image("icon_uncheck")
        static let iconArrowRight = Image("icon_arrow_right")
    }
}
