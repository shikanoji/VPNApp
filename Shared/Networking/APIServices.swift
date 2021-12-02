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
}

enum APIService {
    case getSiteHtml(url: String)
}

extension APIService: TargetType {
    // This is the base URL we'll be using, typically our server.
    var baseURL: URL {
        switch self {
        default:
            return URL(string: "")!
        }
        
    }

    // This is the path of each operation that will be appended to our base URL.
    var path: String {
        switch self {
        default:
            return ""
        }
    }

    // Here we specify which method our calls should use.
    var method: Moya.Method {
        switch self {
        case .getSiteHtml:
            return .get
        }
    }

    // Here we specify body parameters, objects, files etc.
    // or just do a plain request without a body.
    // In this example we will not pass anything in the body of the request.
    var task: Task {
        switch self {
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
