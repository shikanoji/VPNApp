//
//  APIServices.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 02/12/2021.
//

import Moya
import Alamofire

enum APIError: Error {
    case someError
    case tokenError
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
        case .badURL, .parsing, .unknown, .tokenError, .someError, .permissionError, .identified:
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
            return "some error"
        case .tokenError:
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
    case logout
    case refreshToken
    case forgotPassword(email: String)
    case ipInfo
    case ipInfoOptional
    case getRequestCertificate(currentTab: BoardViewModel.StateTab)
    case getObtainCertificate
    case changePassword(oldPassword: String, newPassword: String)
}

extension APIService: TargetType {
    // This is the base URL we'll be using, typically our server.
    var baseURL: URL {
        switch self {
        case .ipInfoOptional:
            return URL(string: Constant.api.ipInfoOptional)!
        default:
            return URL(string: Constant.api.root)!
        }
    }
    
    // This is the path of each operation that will be appended to our base URL.
    var path: String {
        switch self {
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
        case .ipInfo:
            return Constant.api.path.ipInfo
        case .ipInfoOptional:
            return ""
        case .getRequestCertificate:
            return Constant.api.path.requestCertificate
        case .getObtainCertificate:
            return Constant.api.path.obtainCertificate + "/\(NetworkManager.shared.requestCertificate?.requestId ?? "")"
        case .changePassword:
                return Constant.api.path.changePassword
        }
    
    }
    
    // Here we specify which method our calls should use.
    var method: Moya.Method {
        switch self {
        case .getCountryList, .ipInfo, .getRequestCertificate, .ipInfoOptional:
            return .get
        case .register, .login, .logout, .forgotPassword, .refreshToken:
            return .post
        case .getObtainCertificate:
            return .get
        case .changePassword:
            return .put
        }
    }
    
    // Here we specify body parameters, objects, files etc.
    // or just do a plain request without a body.
    // In this example we will not pass anything in the body of the request.
    var task: Task {
        switch self {
        case .register(let email, let password):
            var body: [String: Any] = [:]
            body["email"] = email
            body["password"] = password
            body["ip"] = AppSetting.shared.ip
            body["country"] = AppSetting.shared.countryCode
            body["city"] = AppSetting.shared.cityName
            return .requestCompositeParameters(bodyParameters: body, bodyEncoding: JSONEncoding.prettyPrinted, urlParameters: [:])
        case .login(let email, let password):
            var body: [String: Any] = [:]
            body["email"] = email
            body["password"] = password
            body["ip"] = AppSetting.shared.ip
            body["country"] = AppSetting.shared.countryCode
            body["city"] = AppSetting.shared.cityName
            return .requestCompositeParameters(bodyParameters: body, bodyEncoding: JSONEncoding.prettyPrinted, urlParameters: [:])
        case .logout:
            var body: [String: Any] = [:]
            body["refreshToken"] = AppSetting.shared.refreshToken
            return .requestCompositeParameters(bodyParameters: body, bodyEncoding: JSONEncoding.prettyPrinted, urlParameters: [:])
        case .refreshToken:
            var body: [String: Any] = [:]
            body["refreshToken"] = AppSetting.shared.refreshToken
            body["ip"] = AppSetting.shared.ip
            body["country"] = AppSetting.shared.countryCode
            body["city"] = AppSetting.shared.cityName
            return .requestCompositeParameters(bodyParameters: body, bodyEncoding: JSONEncoding.prettyPrinted, urlParameters: [:])
        case .forgotPassword(let email):
            var body: [String: Any] = [:]
            body["email"] = email
            body["ip"] = AppSetting.shared.ip
            body["country"] = AppSetting.shared.countryCode
            body["city"] = AppSetting.shared.cityName
            return .requestCompositeParameters(bodyParameters: body, bodyEncoding: JSONEncoding.prettyPrinted, urlParameters: [:])
        case .getCountryList:
            var param: [String: Any] = [:]
            // Use "key" temporarily, after remove it
            param["key"] = "f11b69c57d5fe9555e29c57c1d863bf8"
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        case .ipInfo:
            var param: [String: Any] = [:]
            // Use "key" temporarily, after remove it
            param["key"] = "f11b69c57d5fe9555e29c57c1d863bf8"
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        case .ipInfoOptional:
            return .requestPlain
        case .getRequestCertificate(let currentTab):
            var param: [String: Any] = [:]
            // Use "key" temporarily, after remove it
            param["key"] = "f11b69c57d5fe9555e29c57c1d863bf8"
            
            param["tech"] = NetworkManager.shared.selectConfig.getConfigParam
            param["proto"] = NetworkManager.shared.protocolVPN.description
            param["dev"] = "tun"
            
            switch currentTab {
            case .location:
                if let cityNodeSelect = NetworkManager.shared.selectNode {
                    if cityNodeSelect.cityNodeList.count > 0 {
                        param["countryId"] = cityNodeSelect.id
                    } else {
                        param["countryId"] = cityNodeSelect.countryId
                        param["cityId"] = cityNodeSelect.id
                    }
                }
                
//                if let staticServer = NetworkManager.shared.selectStaticServer {
//                    param["serverId"] = staticServer.id
//                }
            case .staticIP:
                if let staticServer = NetworkManager.shared.selectStaticServer {
                    param["serverId"] = staticServer.id
                    param["countryId"] = staticServer.countryId
                }
                
            case .multiHop:
                break
            }
            
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        case .getObtainCertificate:
            var param: [String: Any] = [:]
            // Use "key" temporarily, after remove it
            param["key"] = "f11b69c57d5fe9555e29c57c1d863bf8"
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        case .changePassword(let oldPassword, let newPassword):
            var param: [String: Any] = [:]
            param["oldPassword"] = oldPassword
            param["newPassword"] = newPassword
            return .requestCompositeParameters(bodyParameters: param, bodyEncoding: JSONEncoding.prettyPrinted, urlParameters: [:])
        }
    }
    
    // These are the headers that our service requires.
    // Usually you would pass auth tokens here.
    var headers: [String: String]? {
        switch self {
        case .login, .register:
            return ["Content-type": "application/json"]
        case .getCountryList, .getObtainCertificate, .changePassword:
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
            userCountryName: AppSetting.shared.countryName)
        
        let jsonEncoder = JSONEncoder()
        if let jsonData = try? jsonEncoder.encode(info),
           let json = String(data: jsonData, encoding: String.Encoding.utf8) {
            return json
        }
        
        return ""
    }
}
