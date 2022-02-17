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
        // user feedback
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
        //info for debugging
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
    case getSiteHtml(url: String)
    case getLocationCity
    case getNodeTab
    case register(email: String, password: String, name: String, ip: String, country: String, city: String)
    case login(email: String, password: String, ip: String, country: String, city: String)
}

extension APIService: TargetType {
    // This is the base URL we'll be using, typically our server.
    var baseURL: URL {
        switch self {
        case .getLocationCity:
            return URL(string: Constant.api.getLocationCity)!
        case .getNodeTab:
            return URL(string: Constant.api.getNodeTab)!
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
        default:
            return ""
        }
    }

    // Here we specify which method our calls should use.
    var method: Moya.Method {
        switch self {
        case .getSiteHtml:
            return .get
        case .getLocationCity:
            return .get
        case .getNodeTab:
            return .get
        case .register:
            return .post
        case .login:
            return .post
        }
    }

    // Here we specify body parameters, objects, files etc.
    // or just do a plain request without a body.
    // In this example we will not pass anything in the body of the request.
    var task: Task {
        switch self {
        case .register(let email, let password, let name, let ip, let country, let city):
            var body: [String: Any] = [:]
            body["email"] = email
            body["password"] = password
            body["name"] = name
            body["ip"] = ip
            body["country"] = country
            body["city"] = city
            return .requestCompositeParameters(bodyParameters: body, bodyEncoding: JSONEncoding.prettyPrinted, urlParameters: [:])
        case .login(let email, let password, let ip, let country, let city):
            var body: [String: Any] = [:]
            body["email"] = email
            body["password"] = password
            body["ip"] = ip
            body["country"] = country
            body["city"] = city
            return .requestCompositeParameters(bodyParameters: body, bodyEncoding: JSONEncoding.prettyPrinted, urlParameters: [:])
        default:
            return .requestPlain
        }
    }

    // These are the headers that our service requires.
    // Usually you would pass auth tokens here.
    var headers: [String: String]? {
        switch self {
        case .getSiteHtml:
            return ["Content-type": "text/html"]
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
