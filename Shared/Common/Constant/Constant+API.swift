//
//  Constant+API.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 16/02/2022.
//

import Foundation
extension Constant {
    struct api {
#if DEBUG
        static let root = "https://api.sysvpnconnect.com"
#else
        static let root = "https://prod.sysvpnconnect.com"
#endif
        static let ipInfoOptional = "https://ipinfo.io/json"
        static let termsAndConditionsURL = "https://sysvpn.com/webview/terms-of-service"
        static let privacyPolictyURL = "https://sysvpn.com/webview/privacy-policy"
        struct path {
            static let register = "/shared/module_auth/v1/register"
            static let logout = "/shared/module_auth/v1/logout"
            static let login = "/shared/module_auth/v1/login"
            static let loginSocial = "/shared/module_auth/v1/login-social"
            static let refreshToken = "/shared/module_auth/v1/refresh-tokens"
            static let forgotPassword = "/shared/module_auth/v1/forgot-password"
            static let getCountryList = "app/module_server/v1/country/get_list"
            static let ipInfo = "/app/module_server/v1/app_setting/get_app_settings"
            static let requestCertificate = "/app/module_server/v1/vpn/request_certificate"
            static let obtainCertificate = "/app/module_server/v1/vpn/obtain_certificate"
            static let changePassword = "/shared/module_user/v1/change-password"
            static let getListSession = "/log/module_session/v1/sessions"
            static let disconnectSession = "/shared/module_server/v1/vpn/disconnect_session"
            static let getTopicFaq = "shared/app/module_faq/v1/faqs"
            static let getMultihopList = "app/module_server/v1/multi_hop/get_list"
            static let fetchPaymentHistory = "/web/module_payment/v1/payments/"
            static let deleteAccount = "shared/module_user/v1/delete-account"
            static let verifyReceipt = "web/module_payment/v1/payments/apple-verify"
        }
    }
}
