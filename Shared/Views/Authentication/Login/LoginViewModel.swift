//
//  LoginViewModel.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 09/12/2021.
//

import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var showAlert: Bool = false
    var alertTitle: String = ""
    var alertMessage: String = ""
    func login() {
        print("Login with username = \(username) and password = \(password)")
        alertTitle = "Login Success"
        alertMessage = "Congrats!"
        showAlert = true
    }
}
