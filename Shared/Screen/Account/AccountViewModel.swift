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
        NotificationCenter.default.post(name: Constant.NameNotification.logoutNeedDisconnect, object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            ServiceManager.shared.logout().subscribe {
                result in self.authentication?.logout()
            } onFailure: { error in
                self.authentication?.logout()
            }.disposed(by: self.disposedBag)
        }
    }
}
