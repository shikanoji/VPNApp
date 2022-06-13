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
        static let ipInfoOptional = "https://ipinfo.io/json"
        
        struct path {
            static let register = "/shared/module_auth/v1/register"
            static let logout = "/shared/module_auth/v1/logout"
            static let login = "/shared/module_auth/v1/login"
            static let loginSocial = "/shared/module_auth/v1/login-social"
            static let refreshToken = "/shared/module_auth/v1/refresh-tokens"
            static let forgotPassword = "/shared/module_auth/v1/forgot-password"
            static let getCountryList = "app/module_server/v1/country/get_list"
            static let ipInfo = "/shared/module_server/v1/app/ip_info"
            static let requestCertificate = "/app/module_server/v1/vpn/request_certificate"
            static let obtainCertificate = "/app/module_server/v1/vpn/obtain_certificate"
            static let changePassword = "/shared/module_user/v1/change-password"
            static let getListSession = "/log/module_session/v1/sessions"
            static let disconnectSession = "/shared/module_server/v1/vpn/disconnect_session"
            static let getTopicFaq = "shared/app/module_faq/v1/faqs"
            static let getMultihopList = "app/module_server/v1/multi_hop/get_list"
        }
    }
}
