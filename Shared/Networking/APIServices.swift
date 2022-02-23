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
    
    var localizedDescription: String {
        /// User feedback
        switch self {
        case .badURL, .parsing, .unknown, .tokenError, .someError, .permissionError:
            return "Sorry, something went wrong."
        case .badResponse(_):
            return "Sorry, the connection to our server failed."
        case .url(let error):
            return error?.localizedDescription ?? "Something went wrong."
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
}

extension APIService: TargetType {
    // This is the base URL we'll be using, typically our server.
    var baseURL: URL {
        switch self {
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
        }
    }
    
    // Here we specify which method our calls should use.
    var method: Moya.Method {
        switch self {
        case .getCountryList:
            return .get
        case .register:
            return .post
        case .login:
            return .post
        case .logout:
            return .post
        case .refreshToken:
            return .post
        case .forgotPassword:
            return .post
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
            body["city"] = AppSetting.shared.city
            return .requestCompositeParameters(bodyParameters: body, bodyEncoding: JSONEncoding.prettyPrinted, urlParameters: [:])
        case .login(let email, let password):
            var body: [String: Any] = [:]
            body["email"] = email
            body["password"] = password
            body["ip"] = AppSetting.shared.ip
            body["country"] = AppSetting.shared.countryCode
            body["city"] = AppSetting.shared.city
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
            body["city"] = AppSetting.shared.city
            return .requestCompositeParameters(bodyParameters: body, bodyEncoding: JSONEncoding.prettyPrinted, urlParameters: [:])
        case .forgotPassword(let email):
            var body: [String: Any] = [:]
            body["email"] = email
            body["ip"] = AppSetting.shared.ip
            body["country"] = AppSetting.shared.countryCode
            body["city"] = AppSetting.shared.city
            return .requestCompositeParameters(bodyParameters: body, bodyEncoding: JSONEncoding.prettyPrinted, urlParameters: [:])
        case .getCountryList:
            var param: [String: Any] = [:]
            param["key"] = "f11b69c57d5fe9555e29c57c1d863bf8"
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        }
    }
    
    // These are the headers that our service requires.
    // Usually you would pass auth tokens here.
    var headers: [String: String]? {
        switch self {
        case .login, .register:
            return ["Content-type": "application/json"]
        case .getCountryList:
            return [
                "Content-type": "application/json",
                "Authorization": "Bearer \(AppSetting.shared.accessToken)"
            ]
        default:
            return ["Content-type": "application/json"]
        }
    }
    
    // This is sample return data that you can use to mock and test your services,
    // but we won't be covering this.
    var sampleData: Data {
        return Data()
    }
    
}
