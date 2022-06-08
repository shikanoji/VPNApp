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
    
    func signup(completion: @escaping (RegisterResultModel?) -> Void) {
        showProgressView = true
        APIManager.shared.register(email: email, password: password)
            .subscribe(onSuccess: { [self] response in
                self.showProgressView = false
                if let result = response.result, !result.tokens.access.token.isEmpty, !result.tokens.refresh.token.isEmpty {
                    completion(result)
                } else {
                    let error = response.errors
                    if error.count > 0, let message = error[0] as? String {
                        alertMessage = message
                        showAlert = true
                    }
                    completion(nil)
                }
            }, onFailure: { error in
                self.showProgressView = false
                completion(nil)
            })
            .disposed(by: disposedBag)
    }
    
    //MARK: - Login with Google
    func signupGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        if let rootView = UIApplication.shared.rootViewController {
            GIDSignIn.sharedInstance.signIn(with: config, presenting: rootView) { [unowned self] user, error in
                if let error = error {
                    // ...
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
                APIManager.shared.loginSocial(socialProvider: "google", token: idToken)
                    .subscribe(onSuccess: { [self] response in
                        self.showProgressView = false
                        if let result = response.result {
                            self.authentication?.login(withLoginData: result)
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
                    })
                    .disposed(by: self.disposedBag)
            }
        }
    }
    
    //MARK: - Login with Apple
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
                return
            }
            // MARK: TODO
            /// 1. Set token here
            /// 2. Perform tasks to do after login
            self.appleToken = token
            self.showProgressView = true
            APIManager.shared.loginSocial(socialProvider: "apple", token: token)
                .subscribe(onSuccess: { [self] response in
                    self.showProgressView = false
                    if let result = response.result {
                        self.authentication?.login(withLoginData: result)
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
                })
                .disposed(by: disposedBag)
        }
    }
}
