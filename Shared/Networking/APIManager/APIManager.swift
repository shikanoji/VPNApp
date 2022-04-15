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
import SwiftDate

struct APIManager {
    
    // I'm using a singleton for the sake of demonstration and other lies I tell myself
    static let shared = APIManager()
    
    // This is the provider for the service we defined earlier
    var provider: MoyaProvider<APIService>
    
    private init() {
        let plugin = NetworkLoggerPlugin(configuration: .init(logOptions: .formatRequestAscURL))
        self.provider = MoyaProvider<APIService>(requestClosure: MoyaProvider<APIService>.endpointResolver(), plugins: [plugin])
    }
    
    func getCountryList() -> Single<APIResponse<CountryListResultModel>> {
        return provider.rx
            .request(.getCountryList)
            .map { response in
                let result = try JSONDecoder().decode(APIResponse<CountryListResultModel>.self, from: response.data)
                return result
            }
            .catch { error in
                throw APIError.someError
            }
    }
    
    func getRequestCertificate() -> Single<APIResponse<RequestCertificateModel>> {
        return provider.rx
            .request(.getRequestCertificate)
            .map { response in
                let result = try JSONDecoder().decode(APIResponse<RequestCertificateModel>.self, from: response.data)
                return result
            }
            .catch { error in
                throw APIError.someError
            }
    }
}

extension MoyaProvider {
    /// Handle refresh token
    static func endpointResolver() -> MoyaProvider<APIService>.RequestClosure {
        return { (endpoint, closure) in
            //Getting the original request
            let request = try! endpoint.urlRequest()
            if (request.headers.value(for: "Authorization") != nil) {
                //assume you have saved the existing token somewhere
                if !AppSetting.shared.accessToken.isEmpty, let expiresDate = AppSetting.shared.accessTokenExpires.toDate(), Date().convertTo(region: .local) < expiresDate {
                    // Token is valid, so just resume the original request
                    closure(.success(request))
                    return
                }
                
                //Do a request to refresh the authtoken based on refreshToken
                APIManager.shared.refreshToken().subscribe(onSuccess: { result in
                    closure(.success(request))
                }, onFailure: { error in
                    
                }).disposed(by: DisposeBag())
            } else {
                closure(.success(request))
            }
        }
    }
}
