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
    @Published var showSessionExpired: Bool = false
    @Published var getIpInfoSuccess = false
    
    var alertMessage = ""
    
    let disposedBag = DisposeBag()
    
    /// api get ip info in app
    func getIpInfo(completion: @escaping () -> Void) {
        ServiceManager.shared.getAppSettings()
            .subscribe(onSuccess: { [self] response in
                if let result = response.result{
                    AppSetting.shared.configAppSettings(result)
                    completion()
                } else {
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
        getState()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(sessionExpided),
            name: Constant.NameNotification.sessionExpired,
            object: nil
        )
    }
    
    @objc func sessionExpided() {
        if AppSetting.shared.accessToken != "" {
            showSessionExpired = true
        }
    }
    
    func getState() {
        if AppSetting.shared.accessToken != "" {
            getIpInfo {
                if AppSetting.shared.needLoadApiMap {
                    self.getCountryList {
                        self.getMultihopList {
                            self.getIpInfoSuccess = true
                        }
                    }
                } else {
                    self.getIpInfoSuccess = true
                }
            }
        } else {
            self.getIpInfoSuccess = true
        }
    }
    
    func getCountryList(completion: @escaping () -> Void) {
        guard Connectivity.sharedInstance.isReachable else {
            completion()
            return
        }
        
        ServiceManager.shared.getCountryList()
            .subscribe { response in
                if let result = response.result {
                    AppSetting.shared.saveDataMap(result)
                }
                completion()
            } onFailure: { _ in
                completion()
            }
            .disposed(by: disposedBag)
    }
    
    func getMultihopList(completion: @escaping () -> Void) {
        guard Connectivity.sharedInstance.isReachable else {
            completion()
            return
        }
        
        ServiceManager.shared.getMutihopList()
            .subscribe { response in
                if let result = response.result {
                    AppSetting.shared.saveMutilhopList(result)
                }
                completion()
            } onFailure: { error in
                completion()
            }
            .disposed(by: disposedBag)
    }
    
    /// api get ip info optional
    func getIpInfoOptional(completion: @escaping (()) -> Void) {
        ServiceManager.shared.getIpInfoOptional()
            .subscribe(onSuccess: { [self] response in
                configIpInfo(response)
                completion(())
            }, onFailure: { error in
                completion(())
            })
            .disposed(by: disposedBag)
    }
    
    func configIpInfo(_ ipInfo: IpInfoResultModel) {
        AppSetting.shared.ip = ipInfo.ip
        AppSetting.shared.countryCode = ipInfo.countryCode
        AppSetting.shared.countryName = ipInfo.countryName
        AppSetting.shared.cityName = ipInfo.city
        AppSetting.shared.lastChange = ipInfo.lastChange ?? 0
    }
}
