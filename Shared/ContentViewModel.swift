//
//  ContentViewModel.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 28/02/2022.
//


import Foundation
import SwiftUI
import Firebase
import GoogleSignIn
import AuthenticationServices
import RxSwift

class ContentViewModel: ObservableObject {
    @Published var showAlert: Bool = false
    @Published var getIpInfoSuccess = false
    @Published var showProgressView: Bool = false
    
    var alertMessage = ""
    
    var disposedBag = DisposeBag()
    
    /// api get ip info in app
    func getIpInfo(completion: @escaping () -> Void) {
        showProgressView = true
        
        APIManager.shared.getIpInfo()
            .subscribe(onSuccess: { [self] response in
                self.showProgressView = false
                if let result = response.result{
                    configIpInfo(result)
                    completion()
                } else {
                    let error = response.errors
                    if error.count > 0, let message = error[0] as? String {
                        alertMessage = message
                        showAlert = true
                    } else if !response.message.isEmpty {
                        alertMessage = response.message
                        showAlert = true
                    }
                    self.getIpInfoOptional { _ in
                        completion()
                    }
                }
            }, onFailure: { error in
                self.getIpInfoOptional { _ in
                    completion()
                }
            })
            .disposed(by: disposedBag)
    }
    
    init() {
        getIpInfo {
            self.getIpInfoSuccess = true
        }
    }
    
    /// api get ip info optional
    func getIpInfoOptional(completion: @escaping (()) -> Void) {
        showProgressView = true
        
        APIManager.shared.getIpInfoOptional()
            .subscribe(onSuccess: { [self] response in
                self.showProgressView = false
                configIpInfo(response)
                completion(())
            }, onFailure: { error in
                self.showProgressView = false
                completion(())
            })
            .disposed(by: disposedBag)
    }
    
    func configIpInfo(_ ipInfo: IpInfoResultModel) {
        AppSetting.shared.ip = ipInfo.ip
        AppSetting.shared.countryCode = ipInfo.country
        AppSetting.shared.city = ipInfo.city
        AppSetting.shared.lastChange = ipInfo.lastChange ?? 0
    }
}
