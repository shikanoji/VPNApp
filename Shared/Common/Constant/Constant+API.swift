//
//  Constant+API.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 16/02/2022.
//

import Foundation
extension Constant {
    struct api {
        static let root = "https://api.sysvpnconnect.com"
        static let getLocationCity = "google.com.vn"
        static let getNodeTab = "google.com.vn"
        
        struct path {
            static let register = "/shared/module_auth/v1/register"
            static let login = "/shared/module_auth/v1/login"
        }
    }
}
