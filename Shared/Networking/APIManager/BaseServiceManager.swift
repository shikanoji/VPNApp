//
//  BaseService.swift
//  SysVPN
//
//  Created by Nguyen Dinh Thach on 17/08/2022.
//

import Foundation
import SwiftUI
import Moya
import RxMoya
import RxSwift
import Alamofire

class BaseServiceManager<API: TargetType> {
    let provider = MoyaProvider<API>(session: DefaultAlamofireSession.shared,
        plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .formatRequestAscURL))]
    )
    
    init() {
        self.provider.session.sessionConfiguration.timeoutIntervalForRequest = 10
        self.provider.session.sessionConfiguration.timeoutIntervalForResource = 10
    }
    
    func request(_ api: API) -> Single<Response> {
        return provider.rx.request(api)
            .flatMap {
                if $0.statusCode == 401, !AppSetting.shared.isRefreshingToken {
                    AppSetting.shared.isRefreshingToken = true
                    throw TokenError.tokenExpired
                } else {
                    return Single.just($0)
                }
            }
            .retry { (error: Observable<TokenError>) in
                error.flatMap { error -> Single<APIResponse<RegisterResultModel>> in
                    ServiceManager.shared.refreshToken()
                }
            }
            .handleResponse()
            .retry(AppSetting.shared.refreshTokenError ? 0 : 2)
    }
    
    func cancelTask() {
        provider.session.session.finishTasksAndInvalidate()
    }
}

class DefaultAlamofireSession: Alamofire.Session {
    static let shared: DefaultAlamofireSession = {
        let config = URLSessionConfiguration.default
        config.headers = .default
        config.timeoutIntervalForRequest = Constant.timeout.timeoutIntervalForRequest
        config.timeoutIntervalForResource = Constant.timeout.timeoutIntervalForResource
        config.requestCachePolicy = .useProtocolCachePolicy
        return DefaultAlamofireSession(configuration: config)
    }()
}

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func handleResponse() -> Single<Element> {
        return flatMap { response in
//            if (try? response.map(Token.self)) != nil {
//                //Handle token
//            }
            
            if (200 ... 299) ~= response.statusCode {
                return Single.just(response)
            }
            
            if response.statusCode == 400 {
                return Single.just(response)
            }
            
            if var error = try? response.map(ResponseError.self) {
                error.statusCode = response.statusCode
                return Single.error(error)
            }
            
            // Its an error and can't decode error details from server, push generic message
            let genericError = ResponseError(statusCode: response.statusCode,
                                             message: "empty message")
            return Single.error(genericError)
        }
    }
}

struct ResponseError: Decodable, Error {
    var statusCode: Int?
    let message: String
}

enum TokenError: Swift.Error {
    case tokenExpired
}
