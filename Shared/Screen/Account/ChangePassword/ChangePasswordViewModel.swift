//
//  ChangePasswordViewModel.swift
//  SysVPN
//
//  Created by Da Phan Van on 17/01/2022.
//

import Foundation
import RxSwift

class ChangePasswordViewModel: NSObject, ObservableObject {
    @Published var password = ""
    @Published var newPassword = ""
    @Published var retypePassword = ""
    @Published var showProgressView: Bool = false
    @Published var showAlert: Bool = false
    @Published var changePasswordSuccess = false
    @Published var showChangePasswordPhone = false
    @Published var showChangePasswordiPad = false

    var alertTitle: String = ""
    var alertMessage: String = ""
    let disposedBag = DisposeBag()

    func changePassword() {
        guard newPassword == retypePassword else {
            alertMessage = L10n.Account.ChangePassword.passwordNotMatch
            showAlert = true
            return
        }

        showProgressView = true
        ServiceManager.shared.changePassword(oldPassword: password, newPassword: newPassword)
            .subscribe(onSuccess: { [self] response in
                self.showProgressView = false
                if let _ = response.result {
                    alertMessage = L10n.Account.ChangePassword.success
                    changePasswordSuccess = true
                    showAlert = true
                } else {
                    let error = response.errors
                    if !error.isEmpty, let message = error[0] as? String {
                        alertMessage = message
                        showAlert = true
                    } else if !response.message.isEmpty {
                        alertMessage = response.message
                        showAlert = true
                    }
                }
            }, onFailure: { error in
                if let errorAPI = error as? APIError {
                    self.alertMessage = errorAPI.description
                    self.showAlert = true
                }
                self.showProgressView = false
            })
            .disposed(by: disposedBag)
    }
}
