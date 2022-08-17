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
    
    func getCountryList() -> Single<APIResponse<CountryListResultModel>> {
        return request(.getCountryList)
            .map { response in
                let result = try JSONDecoder().decode(APIResponse<CountryListResultModel>.self, from: response.data)
                return result
            }
            .catch { error in
                throw APIError.someError
            }
    }
    
    func getRequestCertificate(currentTab: BoardViewModel.StateTab) -> Single<APIResponse<RequestCerAPI>> {
        return request(.getRequestCertificate(currentTab: currentTab))
            .map { response in
                let result = try JSONDecoder().decode(APIResponse<RequestCerAPI>.self, from: response.data)
                return result
            }
            .catch { error in
                throw APIError.someError
            }
    }
    
    func getObtainCertificate() -> Single<APIResponse<ObtainCertificateModel>> {
        return request(.getObtainCertificate)
            .map { response in
                let result = try JSONDecoder().decode(APIResponse<ObtainCertificateModel>.self, from: response.data)
                return result
            }
            .catch { error in
                throw APIError.someError
            }
    }
    
    func getListSession(page: Int = 1, limit: Int = 20) -> Single<APIResponse<SessionResult>> {
        return request(.getListSession(page: page, limit: limit))
            .map { response in
                let result = try JSONDecoder().decode(APIResponse<SessionResult>.self, from: response.data)
                return result
            }
            .catch { error in
                throw APIError.someError
            }
    }
    
    func disconnectSession(sessionId: String, terminal: Bool) -> Single<APIResponse<EmptyResult>> {
        return request(.disconnectSession(sessionId: sessionId, terminal: terminal))
            .map { response in
                let result = try JSONDecoder().decode(APIResponse<EmptyResult>.self, from: response.data)
                return result
            }
            .catch { error in
                throw APIError.someError
            }
    }
    
    func getTopicQuestionList() -> Single<APIResponse<[TopicQuestionModel]>> {
        return request(.getTopicQuestionList)
            .map { response in
                let result = try JSONDecoder().decode(APIResponse<[TopicQuestionModel]>.self, from: response.data)
                return result
            }
            .catch { error in
                throw APIError.someError
            }
    }
    
    func getMutihopList() -> Single<APIResponse<[MultihopModel]>> {
        return request(.getMultihopList)
            .map { response in
                let result = try JSONDecoder().decode(APIResponse<[MultihopModel]>.self, from: response.data)
                return result
            }
            .catch { error in
                throw APIError.someError
            }
    }
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
