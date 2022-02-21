//
//  APIManager+Auth.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 16/02/2022.
//

import RxSwift
import Moya
import SwiftyJSON

extension APIManager {
    func login(email: String, password: String, ip: String, country: String, city: String) -> Single<APIResponse<LoginResultModel>> {
        return provider.rx
            .request(.login(email: email, password: password, ip: ip, country: country, city: city))
            .filterSuccessfulStatusAndRedirectCodes()
            .map { response in
                let loginResult = try JSONDecoder().decode(APIResponse<LoginResultModel>.self, from: response.data)
                return loginResult
            }
            .catch { error in
                throw APIError.someError
            }
    }
    
    func register(email: String, password: String, ip: String, country: String, city: String) -> Single<APIResponse<RegisterResultModel>> {
        return provider.rx
            .request(.register(email: email, password: password, ip: ip, country: country, city: city))
            .filterSuccessfulStatusAndRedirectCodes()
            .map { response in
                let registerResult = try JSONDecoder().decode(APIResponse<RegisterResultModel>.self, from: response.data)
                return registerResult
            }
            .catch { error in
                throw APIError.someError
            }
    }
    
    func logout() -> Single<APIResponse<LogoutResult>> {
        return provider.rx
            .request(.logout)
            .filterSuccessfulStatusAndRedirectCodes()
            .map { response in
                let logoutResult = try JSONDecoder().decode(APIResponse<LogoutResult>.self, from: response.data)
                return logoutResult
            }
            .catch { error in
                throw APIError.someError
            }
    }
    
    func refreshToken(ip: String, city: String, country: String)-> Single<APIResponse<RegisterResultModel>> {
        return provider.rx
            .request(.refreshToken(ip: ip, country: country, city: city))
            .filterSuccessfulStatusAndRedirectCodes()
            .map { response in
                let refreshTokenResult = try JSONDecoder().decode(APIResponse<RegisterResultModel>.self, from: response.data)
                return refreshTokenResult
            }
            .catch { error in
                throw APIError.someError
            }
    }
}
