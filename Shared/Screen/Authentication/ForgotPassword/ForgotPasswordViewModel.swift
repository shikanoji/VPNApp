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
    var sendRequestDisable: Bool {
        email.isEmpty
    }
    
    func sendRequest() {
        
    }
}
