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
    
    var requestDeleteSucces: () -> Void
    
    var authentication: Authentication?
    var alertTitle: String = ""
    var alertMessage: String = ""
    var appleToken: String = ""
    var disposedBag = DisposeBag()
    
    init(requestDeleteSucces: @escaping () -> Void) {
        self.requestDeleteSucces = requestDeleteSucces
    }
    
    func requestDeleteAccount() {
        showProgressView = true
        ServiceManager.shared.requestDeleteAccount()
            .subscribe(onSuccess: {[weak self] response in
                guard let strongSelf = self else { return }
                strongSelf.showProgressView = false
                if response.success  {
                    strongSelf.requestDeleteSucces()
                    strongSelf.shouldDismissView = true
                } else {
                    let error = response.errors
                    if !error.isEmpty, let message = error[0] as? String {
                        strongSelf.alertMessage = message
                        strongSelf.showAlert = true
                    } else if !response.message.isEmpty {
                        strongSelf.alertMessage = response.message
                        strongSelf.showAlert = true
                    }
                }
            }, onFailure: {[weak self] error in
                if let errorAPI = error as? APIError {
                    self?.alertMessage = errorAPI.description
                    self?.showAlert = true
                }
                self?.showProgressView = false
            })
            .disposed(by: disposedBag)
    }
}
