//
//  LoginViewModel.swift
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

enum LoginResult {
    case success
    case wrongPassword
    case accountNotExist
}

class LoginViewModel: NSObject, ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showAlert: Bool = false
    @Published var showProgressView: Bool = false
    var alertTitle: String = ""
    var alertMessage: String = ""
    var appleToken: String = ""
    var disposedBag = DisposeBag()
    var authentication: Authentication?
    var loginDisable: Bool {
        email.isEmpty || password.isEmpty
    }
    
    func login(completion: @escaping (LoginResult) -> Void) {
        showProgressView = true
        
        APIManager.shared.login(email: email, password: password, ip: "127.0.0.1", country: "Hanoi", city: "VN")
            .subscribe(onSuccess: { [self] response in
                self.showProgressView = false
                if let result = response.result, !result.tokens.access.token.isEmpty {
//                    authentication?.login(email: result.user.email, password: result.user.password)
                    completion(.success)
                }
            }, onFailure: { error in
                completion(.accountNotExist)
            })
        .disposed(by: disposedBag)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: { [self] in
            self.showProgressView = false
            completion(.success)
        })
    }
    
    //MARK: - Login with Google
    func loginGoogle() {
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
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            }
        }
    }
    
    //MARK: - Login with Apple
    func loginApple() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
}

extension LoginViewModel: ASAuthorizationControllerDelegate {
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
        }
    }
}
