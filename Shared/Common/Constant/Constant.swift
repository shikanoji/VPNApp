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
            static let sizeFont: CGFloat = 15
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
            static let frameEnsign: CGFloat = 20.0
            static let widthTriangle: CGFloat = 12
            static let heightTriangle: CGFloat = 5
            static let backgroudTriangle: Color = .white
            static let cornerRadius: CGFloat = 5
            static let numberLineText = 1
            static let heightContentPopupView: CGFloat = 40
        }
        
        struct Map {
            static let minZoom: CGFloat = 1
            static let maxZoom: CGFloat = 4
            static let enableCityZoom: CGFloat = 2.5
            static let zoomCity: CGFloat = 0.5
            static let widthScreen = UIScreen.main.bounds.width
            static let heightScreen = UIScreen.main.bounds.height
            static let widthMapOrigin: CGFloat = 2048
            static let heightMapOrigin: CGFloat = 1588
            static let ration: CGFloat = widthMapOrigin / heightMapOrigin
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
        static let iconCity = UIImage(named: "icon_board_city")
    }
    
    struct StaticIP {
        static let iconS = Asset.Assets.iconStatic.SuImage
        
        static let widthStatusStatic: CGFloat = 40
        static let heightStatusStatic: CGFloat = 8
    }
    
    struct MultiHop {
        static let iconWhat = Asset.Assets.iconMultihopWhat.SuImage
        static let iconExit = Asset.Assets.iconMultihopExit.SuImage
        static let sizeIcon: CGFloat = 24
    }
    
    struct Global {
        static let errorImage = Asset.Assets.japan.SuImage
        static let iconCheck = Asset.Assets.iconCheckbox.SuImage
        static let iconUncheck = Asset.Assets.iconUncheck.SuImage
        static let iconArrowRight = Asset.Assets.iconArrowRight.SuImage
    }
    
    struct Loading {
        static let sizeCircle: CGFloat = 17.15
        static let sizeLoading: CGFloat = 64
    }
    
    static func convertXToMap(_ x: CGFloat) -> CGFloat {
        return (x / Constant.Board.Map.widthMapOrigin) * Constant.Board.Map.widthScreen
    }
    
    static func convertYToMap(_ y: CGFloat) -> CGFloat {
        return (y / Constant.Board.Map.heightMapOrigin) * (Constant.Board.Map.widthScreen / Constant.Board.Map.ration)
    }
}
