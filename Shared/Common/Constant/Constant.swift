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
            static let falgDefault = "flag-default"
        }
        
        struct SubBoard {
            static let radius: CGFloat = 40
            static let height: CGFloat = 60
            static let fontSize: CGFloat = 12
            static let fontColor: Color = .white
            static let weightFont: Font.Weight = .medium
            static let weightFontStatus: Font.Weight = .semibold
        }
        
        struct IconFrame {
            static let leftIconWidth: CGFloat = 40
            static let rightIconWidth: CGFloat = 40
        }
        
        struct Navigation {
            static let heightNavigationBar: CGFloat = UIDevice.current.hasNotch ? 60 : 40
            static let sizeFont: CGFloat = 14
            static let weightFont: Font.Weight = .bold
        }
        
        struct QuickButton {
            static let widthSize: CGFloat = 95
            static let heightSize: CGFloat = 135
            static let widthBorderMax: CGFloat = 4
            static let sizeDoc: CGFloat = 8
        }
        
        struct Alert {
            static let sizeFont: CGFloat = 15
            static let weightFont: Font.Weight = .semibold
        }
        
        struct Tabs {
            static let heightSize: CGFloat = 36
            static let topPadding: CGFloat = 50
        }
        
        struct Speed {
            static let heightIcon: CGFloat = 20
        }
        
        struct NodePopupView {
            static let sizeFont: CGFloat = 12
            static let weightFont: Font.Weight = .semibold
            static let paddingContent: CGFloat = 3.0
            static let frameEnsign: CGFloat = 16.0
            static let widthTriangle: CGFloat = 12
            static let heightTriangle: CGFloat = 5
            static let backgroudTriangle: Color = .white
            static let cornerRadius: CGFloat = 8
            static let numberLineText = 1
            static let heightContentPopupView: CGFloat = 35
        }
        
        struct Map {
            static let minZoom: CGFloat = 1
            static let maxZoom: CGFloat = 2.5
            static let enableCityZoom: CGFloat = 1.5
            static let zoomCity: CGFloat = 0.5
            static let widthScreen = UIScreen.main.bounds.width
            static let heightScreen = UIScreen.main.bounds.height
            static let widthMapOrigin: CGFloat = 2048
            static let heightMapOrigin: CGFloat = 1588
            static let ration: CGFloat = widthMapOrigin / heightMapOrigin
        }
        
        struct Node {
            static let sizeNode: CGFloat = 16
            static let heightPopupCity: CGFloat = 65
            static let heightPopupCountry: CGFloat = 25
            static let multiConnected: CGFloat = 1.8
            static let multiCityNode: CGFloat = 1.4
            static let multiCountryNode: CGFloat = 1
            static let paddingCenterCity = heightPopupCity - 22
            static let paddingCenterCountry = heightPopupCountry
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
        static let fontItem = Font.system(size: 15, weight: .bold)
        static let radiusCell: CGFloat = 10
        static let heightItemCell: CGFloat = 65
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
        static let iconS = Asset.Assets.iconStatic.swiftUIImage
        
        static let widthStatusStatic: CGFloat = 40
        static let heightStatusStatic: CGFloat = 8
    }
    
    struct MultiHop {
        static let iconWhat = Asset.Assets.iconMultihopWhat.swiftUIImage
        static let iconExit = Asset.Assets.iconMultihopExit.swiftUIImage
        static let sizeIcon: CGFloat = 24
    }
    
    struct Global {
        static let errorImage = Asset.Assets.japan.swiftUIImage
        static let iconCheck = Asset.Assets.iconCheckbox.swiftUIImage
        static let iconUncheck = Asset.Assets.iconUncheck.swiftUIImage
        static let iconArrowRight = Asset.Assets.iconArrowRight.swiftUIImage
        static let widthFormAndButton = UIScreen.main.bounds.width - 64
    }
    
    struct Loading {
        static let sizeCircle: CGFloat = 17.15
        static let sizeLoading: CGFloat = 64
    }
    
    static func convertXToMap(_ x: CGFloat) -> CGFloat {
        return (x / Constant.Board.Map.widthMapOrigin) * (Constant.Board.Map.heightScreen * Constant.Board.Map.ration)
    }
    
    static func convertYToMap(_ y: CGFloat, _ isCityView: Bool = false, _ isMultihopNode: Bool = false) -> CGFloat {
        let statusPopView: CGFloat = isCityView ? 45 : 16
        let topViewMultihop: CGFloat = isMultihopNode ? 12 : 0
        return (y / Constant.Board.Map.heightMapOrigin) * Constant.Board.Map.heightScreen - statusPopView - topViewMultihop
    }
    
    struct NameNotification {
        static let checkAutoconnect = Notification.Name("CheckAutoconnectIfNeeded")
        static let disconnectCurrentSession = Notification.Name("disconnectCurrentSession")
        static let logoutNeedDisconnect = Notification.Name("logoutNeedDisconnect")
        static let changeProtocolSetting = Notification.Name("changeProtocolSetting")
        static let sessionExpired = Notification.Name("sessionExpired")
        static let disconnectedVPN = Notification.Name("disconnectedVPN")
        static let showMap = Notification.Name("showMap")
        static let showIntroPlan = Notification.Name("showIntroPlan")
        static let startFree7DayTrial = Notification.Name("startFree7DayTrial")
        static let connectVPNError = Notification.Name("connectVPNError")
        static let appReadyStart = Notification.Name("appReadyStart")
    }
    
    struct TextSize {
                
        struct Global {
            static let titleLarge: CGFloat = 24
            static let titleMedium: CGFloat = 18
            static let titleDefault: CGFloat = 16
            static let detailDefault: CGFloat = 14
            static let small:CGFloat = 13
            static let description:CGFloat = 12
            static let subcription:CGFloat = 11
        }
        
        struct PlanListCell {
            static let name: CGFloat = 14
            static let savingText: CGFloat = 11
            static let price: CGFloat = 20
            static let description: CGFloat = 12
            static let titleSubcription: CGFloat = 32
            static let header: CGFloat = 15
            static let body: CGFloat = 13
        }
        
        struct StaticIPListView {
            static let staticIP: CGFloat = 12
            static let currentLoad: CGFloat = 9
        }
    }
            
    struct TextSizeButton {
        struct Default {
            static let medium: CGFloat = 14
        }
    }
    
    struct SizeImage {
        static let widthButton: CGFloat = 30
        static let heightButton: CGFloat = 30
    }
    
    struct SizeButton {
        static let widthButtonFull = Constant.Board.Map.widthScreen - 80
    }
    
    struct timeout {
        static let timeoutIntervalForRequest = 5.0
        static let timeoutIntervalForResource = 5.0
    }
}
