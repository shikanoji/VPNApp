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
    @Published var endLoading = false
    var alertMessage = ""
    
    let disposedBag = DisposeBag()
    var authentication: Authentication?
    
    var logged: Bool {
        return AppSetting.shared.idUser != 0
    }
    
    var tokenExit : Bool {
        return AppSetting.shared.accessToken != ""
    }
    
    /// api get ip info in app
    func getIpInfo(completion: @escaping () -> Void) {
        ServiceManager.shared.getAppSettings()
            .subscribe(onSuccess: { [self] response in
                if let result = response.result {
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
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(sessionExpided),
            name: Constant.NameNotification.sessionExpired,
            object: nil
        )
        
        guard Connectivity.sharedInstance.isReachable else {
            endLoading = true
            return
        }
        
        if AppSetting.shared.isConnectedToVpn {
            endLoading = true
        }
        
        configState()
    }
    
    @objc func sessionExpided() {
        if !tokenExit {
            showSessionExpired = true
        }
    }
    
    func configState() {
        if logged {
            if tokenExit {
                if authentication?.isPremium ?? false {
                    loadAppSettingAndData {
                        self.endLoading = true
                    }
                } else {
                    authentication?.isPremium = false
                    endLoading = true
                }
            } else {
                showSessionExpired = true
            }
        } else {
            endLoading = true
        }
    }
    
    func loadAppSettingAndData(completion: @escaping () -> Void) {
        getIpInfo {
            if !AppSetting.shared.isConnectedToVpn && AppSetting.shared.needLoadApiMap {
                self.getCountryList {
                    self.getMultihopList {
                        completion()
                    }
                }
            } else {
                completion()
            }
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
