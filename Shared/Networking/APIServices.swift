//
//  APIServices.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 02/12/2021.
//

import Moya
import Alamofire
import UIKit

enum APIError: Error {
    case someError
    case tokenExpired
    case permissionError
    
    case badURL
    case badResponse(statusCode: Int)
    case url(URLError?)
    case parsing(DecodingError?)
    case unknown
    case identified(alert: String = L10n.Global.error, message: String = L10n.Global.somethingWrong)
    case noInternet
    
    var localizedDescription: String {
        /// User feedback
        switch self {
        case .badURL, .parsing, .unknown, .tokenExpired, .someError, .permissionError, .identified:
            return "Sorry, something went wrong."
        case .badResponse(_):
            return "Sorry, the connection to our server failed."
        case .url(let error):
            return error?.localizedDescription ?? "Something went wrong."
        case .noInternet:
            return "No internet connection"
        }
    }
    
    var description: String {
        /// Info for debugging
        switch self {
        case .unknown: return "unknown error"
        case .badURL: return "invalid URL"
        case .url(let error):
            return error?.localizedDescription ?? "url session error"
        case .parsing(let error):
            return "parsing error \(error?.localizedDescription ?? "")"
        case .badResponse(statusCode: let statusCode):
            return "bad response with status code \(statusCode)"
        case .someError:
            return "An error occurred"
        case .tokenExpired:
            return "token error"
        case .permissionError:
            return "permission error"
        case .identified(_ , let message):
            return message
        case .noInternet:
            return "No internet connection"
        }
    }
    
    var title: String {
        switch self {
        case .identified(let alert, _):
            return alert
        default:
            return "Error"
        }
    }
}

enum APIService {
    case getCountryList
    case register(email: String, password: String)
    case login(email: String, password: String)
    case loginSocial(socialProvider: String, token: String)
    case logout
    case refreshToken
    case forgotPassword(email: String)
    case sendVerifyEmail

    case getAppSettings
    case ipInfoOptional
    case getRequestCertificate(asNewConnection: Bool)
    case changePassword(oldPassword: String, newPassword: String)
    case getListSession(page: Int = 1, limit: Int = 20, isActive: Int = 1)
    case disconnectSession(sessionId: String, terminal: Bool)
    case getTopicQuestionList
    case getMultihopList
    case fetchPaymentHistory(page: Int)
    case deleteAccount
    case verifyReceipt(receipt: String)
    case getStatsByServerId
    case getServerStats
}

extension APIService: TargetType {
    // This is the base URL we'll be using, typically our server.
    var baseURL: URL {
        switch self {
        case .ipInfoOptional:
            return URL(string: Constant.api.ipInfoOptional)!
        case .getTopicQuestionList:
            // update soon
            return URL(string: "https://sysvpn.com/app/module_faq/v1/faqs")!
        default:
            return URL(string: Constant.api.root)!
        }
    }
    
    // This is the path of each operation that will be appended to our base URL.
    var path: String {
        switch self {
        case .getServerStats:
            return Constant.api.path.getServerStats
        case .getStatsByServerId:
            var id = ""
            switch NetworkManager.shared.getValueConfigProtocol {
            case .openVPNUDP, .openVPNTCP:
                if let idOpenVPN = NetworkManager.shared.requestCertificate?.server?.id {
                    id = String(idOpenVPN)
                }
            case .wireGuard:
                if let idWG = NetworkManager.shared.obtainCertificate?.server?.id {
                    id = String(idWG)
                }
            default:
                break
            }
            return Constant.api.path.getStatsByServerId + id
        case .getMultihopList:
            return Constant.api.path.getMultihopList
        case .getTopicQuestionList:
            return ""
        case .register:
            return Constant.api.path.register
        case .login:
            return Constant.api.path.login
        case .logout:
            return Constant.api.path.logout
        case .refreshToken:
            return Constant.api.path.refreshToken
        case .forgotPassword:
            return Constant.api.path.forgotPassword
        case .getCountryList:
            return Constant.api.path.getCountryList + "/\(AppSetting.shared.countryCode)/\(AppSetting.shared.ip)"
        case .getAppSettings:
            return Constant.api.path.ipInfo
        case .ipInfoOptional:
            return ""
        case .getRequestCertificate:
            return Constant.api.path.requestCertificate
        case .changePassword:
            return Constant.api.path.changePassword
        case .getListSession:
            return Constant.api.path.getListSession
        case .disconnectSession:
            return Constant.api.path.disconnectSession
        case .loginSocial:
            return Constant.api.path.loginSocial
        case .fetchPaymentHistory:
            return Constant.api.path.fetchPaymentHistory
        case .deleteAccount:
            return Constant.api.path.deleteAccount
        case .verifyReceipt:
            return Constant.api.path.verifyReceipt
        case .sendVerifyEmail:
            return Constant.api.path.sendVerifyEmail
        }
    }
    
    // Here we specify which method our calls should use.
    var method: Moya.Method {
        switch self {
        case .getCountryList, .getAppSettings, .getRequestCertificate, .ipInfoOptional, .getListSession, .getTopicQuestionList, .getMultihopList, .fetchPaymentHistory, .getStatsByServerId, .getServerStats:
            return .get
        case .register, .login, .loginSocial, .logout, .forgotPassword, .refreshToken, .verifyReceipt, .sendVerifyEmail:
            return .post
        case .changePassword:
            return .put
        case .disconnectSession:
            return .patch
        case .deleteAccount:
            return .delete
        }
    }
    
    // Here we specify body parameters, objects, files etc.
    // or just do a plain request without a body.
    // In this example we will not pass anything in the body of the request.
    var task: Task {
        switch self {
        case .getServerStats:
            return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
        case .getStatsByServerId:
            return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
        case .getMultihopList:
            return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
        case .getTopicQuestionList:
            return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
        case .register(let email, let password):
            var body: [String: Any] = [:]
            body["email"] = email
            body["password"] = password
            if getInfoDevice() != "" {
                body["deviceInfo"] = getInfoDevice()
            }
            return .requestCompositeParameters(bodyParameters: body, bodyEncoding: JSONEncoding.prettyPrinted, urlParameters: [:])
        case .login(let email, let password):
            var body: [String: Any] = [:]
            body["email"] = email
            body["password"] = password
            if getInfoDevice() != "" {
                body["deviceInfo"] = getInfoDevice()
            }
            return .requestCompositeParameters(bodyParameters: body, bodyEncoding: JSONEncoding.prettyPrinted, urlParameters: [:])
        case .loginSocial(let socialProvider, let token):
            var body: [String: Any] = [:]
            body["provider"] = socialProvider
            body["token"] = token
            if getInfoDevice() != "" {
                body["deviceInfo"] = getInfoDevice()
            }
            return .requestCompositeParameters(bodyParameters: body, bodyEncoding: JSONEncoding.prettyPrinted, urlParameters: [:])
        case .logout:
            var body: [String: Any] = [:]
            body["refreshToken"] = AppSetting.shared.refreshToken
            return .requestCompositeParameters(bodyParameters: body, bodyEncoding: JSONEncoding.prettyPrinted, urlParameters: [:])
        case .refreshToken:
            var body: [String: Any] = [:]
            body["refreshToken"] = AppSetting.shared.refreshToken
            if getInfoDevice() != "" {
                body["deviceInfo"] = getInfoDevice()
            }
            return .requestCompositeParameters(bodyParameters: body, bodyEncoding: JSONEncoding.prettyPrinted, urlParameters: [:])
        case .forgotPassword(let email):
            var body: [String: Any] = [:]
            body["email"] = email
            if getInfoDevice() != "" {
                body["deviceInfo"] = getInfoDevice()
            }
            return .requestCompositeParameters(bodyParameters: body, bodyEncoding: JSONEncoding.prettyPrinted, urlParameters: [:])
        case .getCountryList:
            return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
        case .getAppSettings:
            var param: [String: Any] = [:]
            param["platform"] = "ios"
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        case .ipInfoOptional:
            return .requestPlain
        case .getRequestCertificate(let asNewConnection):
            var param: [String: Any] = [:]
            param["tech"] = NetworkManager.shared.getValueConfigProtocol.getConfigParam
            param["proto"] = NetworkManager.shared.getValueConfigProtocol.getProtocolVPN
            param["dev"] = "tun"
            param["cybersec"] = AppSetting.shared.selectCyberSec ? 1 : 0
            
            switch AppSetting.shared.getBoardTabWhenConnecting() {
            case .location:
                param["isHop"] = 0
                
                if let cityNodeSelect = NetworkManager.shared.getNodeConnect() {
                    NetworkManager.shared.nodeConnecting = cityNodeSelect
                    if cityNodeSelect.cityNodeList.count > 0 {
                        param["countryId"] = cityNodeSelect.id
                    } else {
                        param["cityId"] = cityNodeSelect.id
                    }
                } else {
                    print("cityNodeSelect empty")
                }

            case .staticIP:
                param["isHop"] = 0
                if let staticServer = NetworkManager.shared.selectStaticServer {
                    param["serverId"] = staticServer.id
                }
                
            case .multiHop:
                param["isHop"] = 1
                if let multihop = NetworkManager.shared.selectMultihop,
                   let serverId = multihop.entry?.serverId,
                   let city = multihop.exit?.city {
                    param["countryId"] = city.countryId
                    param["cityId"] = city.id
                    param["serverId"] = serverId
                }
                break
            }
            
            var prevSessionId = ""
            switch NetworkManager.shared.getValueConfigProtocol {
            case .openVPNTCP, .openVPNUDP:
                prevSessionId = NetworkManager.shared.requestCertificate?.sessionId ?? ""
                param["proto"] = NetworkManager.shared.getValueConfigProtocol.getProtocolVPN
            case .wireGuard:
                prevSessionId = NetworkManager.shared.obtainCertificate?.sessionId ?? ""
            default:
                break
            }
            if prevSessionId != "", !asNewConnection {
                param["prevSessionId"] = prevSessionId
            }
            
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        case .changePassword(let oldPassword, let newPassword):
            var param: [String: Any] = [:]
            if !oldPassword.isEmpty {
                param["oldPassword"] = oldPassword
            }
            param["newPassword"] = newPassword
            return .requestCompositeParameters(bodyParameters: param, bodyEncoding: JSONEncoding.prettyPrinted, urlParameters: [:])
        case .getListSession(let page, let limit, let isActive):
            var param: [String: Any] = [:]
            param["page"] = page
            param["limit"] = limit
            param["isActive"] = isActive
            param["sortBy"] = "createdAt:desc"
            param["userId"] = AppSetting.shared.idUser
            
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
            
        case .disconnectSession(let sessionId, let terminal):
            var body: [String: Any] = [:]
            body["sessionId"] = sessionId
            body["disconnectedBy"] = terminal ? "client_terminate" : "client"
            
            return .requestCompositeParameters(
                bodyParameters: body,
                bodyEncoding: JSONEncoding.prettyPrinted,
                urlParameters:  [:])
        case .fetchPaymentHistory(let page):
            var param: [String: Any] = [:]
            param["page"] = page
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        case .verifyReceipt(let receipt):
            
            var body: [String: Any] = [:]
            body["type"] = "APPLE_INAPP"
            body["userId"] = AppSetting.shared.idUser
            body["receipt"] = receipt
            
            return .requestCompositeParameters(
                bodyParameters: body,
                bodyEncoding: JSONEncoding.prettyPrinted,
                urlParameters: [:])
        case .sendVerifyEmail:
            var body: [String: Any] = [:]
            if getInfoDevice() != "" {
                body["deviceInfo"] = getInfoDevice()
            }
            return .requestCompositeParameters(bodyParameters: body, bodyEncoding: JSONEncoding.prettyPrinted, urlParameters: [:])
        default:
            return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
        }
    }
    
    // These are the headers that our service requires.
    // Usually you would pass auth tokens here.
    var headers: [String: String]? {
        switch self {
        case .fetchPaymentHistory:
            return [
                "Authorization": "Bearer \(AppSetting.shared.accessToken)",
                "Content-type": "application/json",
                "x-api-key": "4368c9a9-e8a7-4e66-89cb-97c801c5dd88"
            ]
        case .getServerStats:
            return [
                "Authorization": "Bearer \(AppSetting.shared.accessToken)"
            ]
        case .getStatsByServerId:
            return [
                "Authorization": "Bearer \(AppSetting.shared.accessToken)"
            ]
        case .login, .register:
            return ["Content-type": "application/json"]
        case .getCountryList, .changePassword, .getListSession, .getTopicQuestionList, .getMultihopList, .disconnectSession, .deleteAccount, .sendVerifyEmail:
            return [
                "Content-type": "application/json",
                "Authorization": "Bearer \(AppSetting.shared.accessToken)"
            ]
        case .getRequestCertificate:
            var baseHeader = [
                "Content-type": "application/json",
                "Authorization": "Bearer \(AppSetting.shared.accessToken)"
            ]
            
            if getInfoDevice() != "" {
                baseHeader["x-device-info"] = getInfoDevice()
            }
            baseHeader["x-user-info"] = "{\"id\": \(AppSetting.shared.idUser)}"
            
            return baseHeader
        case .verifyReceipt:
            let baseHeader = [
                "Content-type": "application/json",
                "x-api-key": "4368c9a9-e8a7-4e66-89cb-97c801c5dd88"
            ]
            return baseHeader
        default:
            return ["Content-type": "application/json"]
        }
    }
    
    // This is sample return data that you can use to mock and test your services,
    // but we won't be covering this.
    var sampleData: Data {
        return Data()
    }
    
    
    func getInfoDevice() -> String {
        let info = InfoDeviceModel(
            ipAddress: AppSetting.shared.ip,
            deviceId: UIDevice.current.identifierForVendor!.uuidString,
            deviceBrand: UIDevice.modelName,
            deviceOs: "iOS",
            deviceModel: UIDevice.current.model,
            deviceIsRoot: AppSetting.shared.wasJailBreak,
            deviceManufacture: "Apple",
            deviceFreeMemory: Int(GetFreeMemory().get_free_memory()),
            osBuildNumber: UIDevice.current.systemVersion,
            appVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            appBundleId: Bundle.main.bundleIdentifier,
            isEmulator: TARGET_OS_SIMULATOR != 0 ? 1 : 0,
            isTablet: UIDevice.current.userInterfaceIdiom == .pad ? 1 : 0,
            userCountryCode: AppSetting.shared.countryCode,
            userCountryName: AppSetting.shared.countryName,
            userCity: AppSetting.shared.cityName)
        
        let jsonEncoder = JSONEncoder()
        if let jsonData = try? jsonEncoder.encode(info),
           let json = String(data: jsonData, encoding: String.Encoding.utf8) {
            return json
        }
        
        return ""
    }
}
