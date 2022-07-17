//
//  PaymentHistoryViewModel.swift
//  SysVPN
//
//  Created by Nguyen Dinh Thach on 17/07/2022.
//

import Foundation
import RxSwift

class PaymentHistoryViewModel: ObservableObject {
    let disposedBag = DisposeBag()
    @Published var paymentHistory: [PaymentHistoryRow] = []
    @Published var showProgressView: Bool = false
    func fetchPaymentHistory() {
        showProgressView = true
        APIManager.shared.fetchPaymentHistory()
            .subscribe(onSuccess: { [weak self] response in
                guard let strongSelf = self else { return }
                if let result = response.result {
                    let paymentList = result.rows
                    strongSelf.showProgressView = false
                    strongSelf.paymentHistory = paymentList
                }
                
            }, onFailure: { [weak self]  error in
                guard let strongSelf = self else { return }
                strongSelf.showProgressView = false
            })
            .disposed(by: disposedBag)
    }
}
