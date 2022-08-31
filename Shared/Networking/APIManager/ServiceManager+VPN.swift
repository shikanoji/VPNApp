//
//  ServiceManager+VPN.swift
//  SysVPN
//
//  Created by Nguyen Dinh Thach on 19/08/2022.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON
import SwiftUI

extension ServiceManager {
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
    
    func getRequestCertificate(currentTab: StateTab, asNewConnection: Bool = false) -> Single<APIResponse<RequestCerAPI>> {
        return request(.getRequestCertificate(currentTab: currentTab, asNewConnection: asNewConnection))
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
