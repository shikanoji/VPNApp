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
        
        struct path {
            static let register = "/shared/module_auth/v1/register"
            static let logout = "/shared/module_auth/v1/logout"
            static let login = "/shared/module_auth/v1/login"
            static let refreshToken = "/shared/module_auth/v1/refresh-tokens"
            static let forgotPassword = "/shared/module_auth/v1/forgot-password"
            static let getCountryList = "app/module_server/v1/country/get_list"
        }
    }
}
