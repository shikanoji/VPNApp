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
    private var provider: MoyaProvider<APIService>
    
    private init() {
        let plugin = NetworkLoggerPlugin(configuration: .init(logOptions: .formatRequestAscURL))
        self.provider = MoyaProvider<APIService>(plugins: [plugin])
    }
    
    
    func getSiteHtml(withUrl url: String) -> Single<String> {
        return provider.rx
            .request(.getSiteHtml(url: url))
            .filterSuccessfulStatusAndRedirectCodes()
            .map { response in
                return try response.mapString()
            }
            .catch { error in
                throw APIError.someError
            }
    }
    
    func getLocationCity() -> Single<[Node]> {
        return provider.rx
            .request(.getLocationCity)
            .filterSuccessfulStatusAndRedirectCodes()
            .map { response in
                return try response.map([Node].self)
            }
            .catch { error in
                throw APIError.someError
            }
    }
}
