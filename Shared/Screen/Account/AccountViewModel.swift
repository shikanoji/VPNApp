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
    @Published var showLogoutConfirmationPhone = false
    @Published var showLogoutConfirmationPad = false
    @Published var showSuccessfullyResendEmail = false
    @Published var shouldShowResendEmailButton = AppSetting.shared.shouldAllowSendVerifyEmail
    var disposedBag = DisposeBag()
    var alertTitle: String = ""
    var alertMessage: String = ""
    var authentication: Authentication?

    func logout() {
        NotificationCenter.default.post(name: Constant.NameNotification.logoutNeedDisconnect, object: nil)

        if !AppSetting.shared.currentSessionId.isEmpty {
            ServiceManager.shared.disconnectSession(sessionId: AppSetting.shared.currentSessionId, terminal: true)
                .subscribe { [weak self] response in
                    guard let self = self else {
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
                .disposed(by: disposedBag)
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
        showProgressView = true
        ServiceManager.shared.sendVerifiedEmail().subscribe {
            result in
            self.showProgressView = false
            if result.success {
                self.showSuccessfullyResendEmail = true
                AppSetting.shared.lastTimeSendVerifyEmail = Int(Date().timeIntervalSince1970)
                self.shouldShowResendEmailButton = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 60, execute: {
                    self.shouldShowResendEmailButton = true
                })
            } else {
                self.showAlert = true
            }
        } onFailure: { error in
            if let errorAPI = error as? APIError {
                self.alertMessage = errorAPI.description
                self.showAlert = true
            }
            self.showProgressView = false
        }.disposed(by: disposedBag)
    }
}
