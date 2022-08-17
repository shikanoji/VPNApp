//
//  BaseService.swift
//  SysVPN
//
//  Created by Nguyen Dinh Thach on 17/08/2022.
//

import Foundation

import Moya
import RxMoya
import RxSwift

class BaseServiceManager<API: TargetType> {
    private let provider = MoyaProvider<API>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .formatRequestAscURL))])
    
    func request(_ api: API) -> Single<Response> {
        return provider.rx.request(api)
            .flatMap {
                if $0.statusCode == 401 {
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
            .filterSuccessfulStatusCodes()
            .retry(2)
    }
    
    func cancelTask() {
        provider.session.session.finishTasksAndInvalidate()
    }
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
