//
//  DeleteAccountConfirmationViewModel.swift
//  SysVPN
//
//  Created by Nguyen Dinh Thach on 18/07/2022.
//

import Foundation
import RxSwift

class DeleteAccountConfirmationViewModel: ObservableObject {
    @Published var showAlert: Bool = false
    @Published var showProgressView: Bool = false
    @Published var shouldDismissView: Bool = false
    var authentication: Authentication?
    var alertTitle: String = ""
    var alertMessage: String = ""
    var appleToken: String = ""
    var disposedBag = DisposeBag()
    func deleteAccount() {
        showProgressView = true
        ServiceManager.shared.deleteAccount()
            .subscribe(onSuccess: {[weak self] response in
                guard let strongSelf = self else { return }
                strongSelf.showProgressView = false
                if response.result != nil {
                    strongSelf.shouldDismissView = true
                    strongSelf.authentication?.logout()
                } else {
                    let error = response.errors
                    if error.count > 0, let message = error[0] as? String {
                        strongSelf.alertMessage = message
                        strongSelf.showAlert = true
                    } else if !response.message.isEmpty {
                        strongSelf.alertMessage = response.message
                        strongSelf.showAlert = true
                    }
                }
            }, onFailure: {[weak self] error in
                self?.showProgressView = false
            })
            .disposed(by: disposedBag)
    }
}
