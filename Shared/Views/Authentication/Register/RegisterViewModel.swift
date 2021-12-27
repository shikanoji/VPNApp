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

enum RegisterResult {
    case success
    case wrongPassword
    case accountNotExist
}

class RegisterViewModel: NSObject, ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var retypePassword: String = ""
    @Published var showAlert: Bool = false
    @Published var showProgressView: Bool = false
    var alertTitle: String = ""
    var alertMessage: String = ""
    var appleToken: String = ""
    var loginDisable: Bool {
        username.isEmpty || password.isEmpty
    }
    
    func signup(completion: @escaping (RegisterResult) -> Void) {
        //        alertTitle = "Login Success"
        //        alertMessage = "Congrats!"
        //        showAlert = true
        showProgressView = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: { [self] in
            self.showProgressView = false
            completion(.success)
        })
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
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
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
        }
    }
}
