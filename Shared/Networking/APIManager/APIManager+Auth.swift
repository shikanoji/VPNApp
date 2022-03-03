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
    func login(email: String, password: String) -> Single<APIResponse<LoginResultModel>> {
        return provider.rx
            .request(.login(email: email, password: password))
            .map { response in
                let loginResult = try JSONDecoder().decode(APIResponse<LoginResultModel>.self, from: response.data)
                return loginResult
            }
            .catch { error in
                throw APIError.someError
            }
    }
    
    func register(email: String, password: String) -> Single<APIResponse<RegisterResultModel>> {
        return provider.rx
            .request(.register(email: email, password: password))
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
            .map { response in
                let logoutResult = try JSONDecoder().decode(APIResponse<LogoutResult>.self, from: response.data)
                return logoutResult
            }
            .catch { error in
                throw APIError.someError
            }
    }
    
    func refreshToken()-> Single<APIResponse<RegisterResultModel>> {
        return provider.rx
            .request(.refreshToken)
            .filterSuccessfulStatusAndRedirectCodes()
            .map { response in
                let refreshTokenResult = try JSONDecoder().decode(APIResponse<RegisterResultModel>.self, from: response.data)
                if let result = refreshTokenResult.result {
                    let tokens = result.tokens
                    AppSetting.shared.accessToken = tokens.access.token
                    AppSetting.shared.accessTokenExpires = tokens.access.expires
                    AppSetting.shared.refreshToken = tokens.refresh.token
                    AppSetting.shared.refreshTokenExpires = tokens.refresh.expires
                }
                return refreshTokenResult
            }
            .catch { error in
                throw APIError.someError
            }
    }
    
    func getIpInfo() -> Single<APIResponse<IpInfoResultModel>> {
        return provider.rx
            .request(.ipInfo)
            .map { response in
                let ipInfoResult = try JSONDecoder().decode(APIResponse<IpInfoResultModel>.self, from: response.data)
                return ipInfoResult
            }
            .catch { error in
                throw APIError.someError
            }
    }
    
    func getIpInfoOptional() -> Single<IpInfoResultModel> {
        return provider.rx
            .request(.ipInfoOptional)
            .map { response in
                let ipInfoResult = try JSONDecoder().decode(IpInfoResultModel.self, from: response.data)
                return ipInfoResult
            }
            .catch { error in
                throw APIError.someError
            }
    }
}
