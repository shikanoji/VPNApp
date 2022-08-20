//
//  ServiceManager.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 02/12/2021.
//

import RxSwift
import Moya
import SwiftyJSON
import SwiftUI

final class ServiceManager: BaseServiceManager<APIService> {
    static let shared = ServiceManager()
    
    // This is the provider for the service we defined earlier
//    var provider: MoyaProvider<APIService>
//
//    private init() {
//        let plugin = NetworkLoggerPlugin(configuration: .init(logOptions: .formatRequestAscURL))
//        self.provider = MoyaProvider<APIService>(requestClosure: MoyaProvider<APIService>.endpointResolver(), plugins: [plugin])
//        self.provider.session.sessionConfiguration.timeoutIntervalForRequest = 10
//        self.provider.session.sessionConfiguration.timeoutIntervalForResource = 10
//    }
}

//extension MoyaProvider {
//    /// Handle refresh token
//    static func endpointResolver() -> MoyaProvider<APIService>.RequestClosure {
//        return { (endpoint, closure) in
//            //Getting the original request
//            let request = try! endpoint.urlRequest()
//            if (request.headers.value(for: "Authorization") != nil) {
//                //assume you have saved the existing token somewhere
//                if AppSetting.shared.isRefreshTokenValid {
//                    // Token is valid, so just resume the original request
//                    closure(.success(request))
//                    return
//                }
//
//                //Do a request to refresh the authtoken based on refreshToken
//                ServiceManager.shared.refreshToken().subscribe(onSuccess: { result in
//                    closure(.success(request))
//                }, onFailure: { error in
//                    //Refresh token failed
//                }).disposed(by: DisposeBag())
//            } else {
//                closure(.success(request))
//            }
//        }
//    }
//}
