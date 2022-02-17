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
}
