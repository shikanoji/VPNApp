//
//  Constant.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 02/12/2021.
//

import Foundation
import UIKit

struct Constant {
    struct api {
        static let root = "google.com.vn"
    }
    
    struct Board {
        struct Image {
            static let setting = "icon_setting_board"
            static let user = "icon_user_board"
            static let unconnect = "icon_unconnect_board"
            static let connected = "icon_connected_board"
        }
        
        struct SubBoard {
            static let radius: CGFloat = 8
            static let height: CGFloat = 68
        }
        
        struct IconFrame {
            static let leftIconWidth: CGFloat = 30
            static let rightIconWidth: CGFloat = 30
        }
        
        struct Navigation {
            static let heightNavigationBar: CGFloat = 60
            static let sizeFont: CGFloat = 14
        }
    }
}
