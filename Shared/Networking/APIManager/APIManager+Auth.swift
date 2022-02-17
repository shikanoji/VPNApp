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
    func login(email: String, password: String, ip: String, country: String, city: String) -> Single<LoginResultModel?> {
        return provider.rx
            .request(.login(email: email, password: password, ip: ip, country: country, city: city))
            .filterSuccessfulStatusAndRedirectCodes()
            .map { response in
                let decoder = JSONDecoder()
                let json = try JSON(data: response.data)
                if json["success"].boolValue == true, let result = json["result"].dictionaryObject {
                    let loginResult = try decoder.decode(LoginResultModel.self, from: JSON(result).rawData() )
                    return loginResult
                }
                
                return nil
            }
            .catch { error in
                throw APIError.someError
            }
    }
}
