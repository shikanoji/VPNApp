//
//  ChangePasswordViewModel.swift
//  SysVPN
//
//  Created by Da Phan Van on 17/01/2022.
//

import Foundation

class ChangePasswordViewModel: NSObject, ObservableObject {
    @Published var password = ""
    @Published var newPassword = ""
    @Published var retypePassword = ""
    @Published var showProgressView: Bool = false
    
    func changePassword(completion: @escaping (LoginResult) -> Void) {
        //        alertTitle = "Login Success"
        //        alertMessage = "Congrats!"
        //        showAlert = true
        showProgressView = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: { [self] in
            self.showProgressView = false
            completion(.success)
        })
    }
}
