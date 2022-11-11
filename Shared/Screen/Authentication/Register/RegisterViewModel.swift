//
//  RegisterViewModel.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 09/12/2021.
//

import Foundation
import SwiftUI
import Firebase
import GoogleSignIn
import AuthenticationServices
import RxSwift

class RegisterViewModel: NSObject, ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var retypePassword: String = ""
    @Published var showAlert: Bool = false
    @Published var showProgressView: Bool = false
    var authentication: Authentication?
    var alertTitle: String = ""
    var alertMessage: String = ""
    var appleToken: String = ""
    var registerDisable: Bool {
        email.isEmpty || password.isEmpty || retypePassword.isEmpty
    }
    private let disposedBag = DisposeBag()

    func signup() {
        guard !registerDisable else {
            alertMessage = "Invalid email or password"
            showAlert = true
            return
        }
        showProgressView = true
        ServiceManager.shared.register(email: email, password: password)
            .subscribe(onSuccess: { [weak self] response in
                self?.showProgressView = false
                if let result = response.result, !result.tokens.access.token.isEmpty, !result.tokens.refresh.token.isEmpty {
                    self?.authentication?.login(withLoginData: result.convertToLoginModel())
                } else {
                    let error = response.errors
                    if !error.isEmpty, let message = error[0] as? String {
                        self?.alertMessage = message
                        self?.showAlert = true
                    }
                }
            }, onFailure: { error in
                self.showProgressView = false
            })
            .disposed(by: disposedBag)
    }

    // MARK: - Login with Google
    func signupGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        if let rootView = UIApplication.shared.rootViewController {
            GIDSignIn.sharedInstance.signIn(with: config, presenting: rootView) { [unowned self] user, error in
                if let _ = error {
                    return
                }
                guard
                    let authentication = user?.authentication,
                    let idToken = authentication.idToken
                else {
                    return
                }
//                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
                self.showProgressView = true
                ServiceManager.shared.loginSocial(socialProvider: "google", token: idToken)
                    .subscribe(onSuccess: { [weak self] response in
                        self?.showProgressView = false
                        if let result = response.result {
                            self?.authentication?.login(withLoginData: result)
                        } else {
                            let error = response.errors
                            if !error.isEmpty, let message = error[0] as? String {
                                self?.alertMessage = message
                                self?.showAlert = true
                            } else if !response.message.isEmpty {
                                self?.alertMessage = response.message
                                self?.showAlert = true
                            }
                        }
                    }, onFailure: { error in
                        self.showProgressView = false
                    })
                    .disposed(by: self.disposedBag)
            }
        }
    }

    // MARK: - Login with Apple
    func signupApple() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
}

extension RegisterViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let token = appleIdCredential.identityToken?.base64EncodedString()  else {
                alertMessage = L10n.Global.somethingWrong
                showAlert = true
                return
            }
            // MARK: TODO
            /// 1. Set token here
            /// 2. Perform tasks to do after login
            appleToken = token
            showProgressView = true
            ServiceManager.shared.loginSocial(socialProvider: "apple", token: token)
                .subscribe(onSuccess: { [weak self] response in
                    self?.showProgressView = false
                    if let result = response.result {
                        self?.authentication?.login(withLoginData: result)
                    } else {
                        let error = response.errors
                        if !error.isEmpty, let message = error[0] as? String {
                            self?.alertMessage = message
                            self?.showAlert = true
                        } else if !response.message.isEmpty {
                            self?.alertMessage = response.message
                            self?.showAlert = true
                        }
                    }
                }, onFailure: { error in
                    self.showProgressView = false
                })
                .disposed(by: disposedBag)
        }
    }
}
