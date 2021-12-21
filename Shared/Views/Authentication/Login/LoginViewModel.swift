//
//  LoginViewModel.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 09/12/2021.
//

import Foundation
import SwiftUI

enum LoginResult {
    case success
    case wrongPassword
    case accountNotExist
}

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var showAlert: Bool = false
    @Published var showProgressView: Bool = false
    var alertTitle: String = ""
    var alertMessage: String = ""
    
    var loginDisable: Bool {
        username.isEmpty || password.isEmpty
    }
    func login(completion: @escaping (LoginResult) -> Void) {
//        alertTitle = "Login Success"
//        alertMessage = "Congrats!"
//        showAlert = true
        showProgressView = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            self.showProgressView = false
            completion(.success)
        })
    }
}
