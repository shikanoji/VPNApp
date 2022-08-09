//
//  ForgotPasswordViewModel.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 28/12/2021.
//

import Foundation
import SwiftUI
import Firebase
import GoogleSignIn
import AuthenticationServices
import RxSwift

enum ForgotPasswordRequestResult {
    case success
    case error
}

class ForgotPasswordViewModel: ObservableObject {
    @Published var showAlert: Bool = false
    @Published var showProgressView: Bool = false
    @Published var email: String = ""
    var alertTitle: String = ""
    var alertMessage: String = ""
    private let disposedBag = DisposeBag()
    var sendRequestDisable: Bool {
        email.isEmpty
    }
    
    func sendRequest() {
        showProgressView = true
        APIManager.shared.forgotPassword(email: email)
            .subscribe(onSuccess: { [self] response in
                self.showProgressView = false
                if response.result != nil {
                    alertMessage = L10n.ForgotPassword.success
                    showAlert = true
                } else {
                    let error = response.errors
                    if error.count > 0, let message = error[0] as? String {
                        alertMessage = message
                        showAlert = true
                    } else if !response.message.isEmpty {
                        alertMessage = response.message
                        showAlert = true
                    }
                }
            }, onFailure: { error in
                self.showProgressView = false
                self.alertMessage = L10n.Global.somethingWrong
                self.showAlert = true
            })
            .disposed(by: disposedBag)
    }
}