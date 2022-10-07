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
    
    var page = 1
    var enableLoadMore = false
    
    func fetchPaymentHistory(_ loadMore: Bool = false) {
        showProgressView = true
        
        if loadMore {
            if enableLoadMore {
                page += 1
            } else {
                return
            }
        } else {
            page = 1
        }
        
        ServiceManager.shared.fetchPaymentHistory(page: page)
            .subscribe(onSuccess: { [weak self] response in
                guard let strongSelf = self else { return }
                if let result = response.result {
                    strongSelf.enableLoadMore = (result.rows.count >= result.limit) && (strongSelf.page <= result.totalPages)
                    let paymentList = result.rows
                    strongSelf.showProgressView = false
                    if loadMore {
                        strongSelf.paymentHistory += paymentList
                    } else {
                        strongSelf.paymentHistory = paymentList
                    }
                }
                
            }, onFailure: { [weak self]  error in
                guard let strongSelf = self else { return }
                strongSelf.showProgressView = false
            })
            .disposed(by: disposedBag)
    }
}
