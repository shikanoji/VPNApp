//
//  AccountViewModel.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 21/02/2022.
//

import Foundation
import RxSwift

class AccountViewModel: ObservableObject {
    @Published var showAlert = false
    @Published var showLogoutConfirmation = false
    var disposedBag = DisposeBag()
    var alertTitle: String = ""
    var alertMessage: String = ""
    var authentication: Authentication?
    func logout(){
        APIManager.shared.logout().subscribe { result in
            self.authentication?.logout()
        } onFailure: { error in
            self.authentication?.logout()
        }.disposed(by: disposedBag)
    }
}
