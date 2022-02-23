//
//  APIManager.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 02/12/2021.
//

import RxSwift
import Moya
import SwiftyJSON
import SwiftUI

struct APIManager {

    // I'm using a singleton for the sake of demonstration and other lies I tell myself
    static let shared = APIManager()
    
    // This is the provider for the service we defined earlier
    var provider: MoyaProvider<APIService>
    
    private init() {
        let plugin = NetworkLoggerPlugin(configuration: .init(logOptions: .formatRequestAscURL))
        self.provider = MoyaProvider<APIService>(plugins: [plugin])
    }
    
    func getCountryList() -> Single<APIResponse<CountryListResultModel>> {
        return provider.rx
            .request(.getCountryList)
            .filterSuccessfulStatusAndRedirectCodes()
            .map { response in
                let result = try JSONDecoder().decode(APIResponse<CountryListResultModel>.self, from: response.data)
                return result
            }
            .catch { error in
                throw APIError.someError
            }
    }
}
