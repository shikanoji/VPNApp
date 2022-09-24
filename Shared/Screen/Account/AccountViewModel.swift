//
//  AccountViewModel.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 21/02/2022.
//

import Foundation
import RxSwift

class AccountViewModel: ObservableObject {
    @Published var showAlert = false
    @Published var showProgressView = false
    @Published var showLogoutConfirmation = false
    @Published var showSuccessfullyResendEmail = false
    @Published var shouldShowResendEmailButton = AppSetting.shared.shouldAllowSendVerifyEmail
    var disposedBag = DisposeBag()
    var alertTitle: String = ""
    var alertMessage: String = ""
    var authentication: Authentication?
    
    func logout(){
        AppSetting.shared.temporaryDisableAutoConnect = true
        AppSetting.shared.needToStartNewSession = true
        NotificationCenter.default.post(name: Constant.NameNotification.logoutNeedDisconnect, object: nil)

        if !AppSetting.shared.currentSessionId.isEmpty {
            ServiceManager.shared.disconnectSession(sessionId: AppSetting.shared.currentSessionId, terminal: true)
                .subscribe { [weak self] response in
                    guard let `self` = self else {
                        return
                    }
                    if response.success {
                        self.callLogoutAPI()
                    } else {
                        self.disconnetAndLogout()
                    }
                } onFailure: { error in
                    self.disconnetAndLogout()
                }
                .disposed(by: self.disposedBag)
        } else {
            callLogoutAPI()
        }
    }
    
    func disconnetAndLogout() {
        NetworkManager.shared.disconnect()
        callLogoutAPI()
    }

    func callLogoutAPI() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            ServiceManager.shared.logout().subscribe {
                result in
                self.showProgressView = false
                self.authentication?.logout()
            } onFailure: { error in
                self.showProgressView = false
                self.authentication?.logout()
            }.disposed(by: self.disposedBag)
        })
    }

    func resendVerifyEmail() {
        ServiceManager.shared.sendVerifiedEmail().subscribe {
            result in
            if result.success {
                self.showSuccessfullyResendEmail = true
                AppSetting.shared.lastTimeSendVerifyEmail = Int(Date().timeIntervalSince1970)
                self.shouldShowResendEmailButton = false
            } else {
                self.showAlert = true
            }
        } onFailure: { error in
            self.showAlert = true
        }.disposed(by: self.disposedBag)
    }
}
