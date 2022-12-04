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
    @Published var showAlert: Bool = false
    
    var error: AppAPIError = .someError
    
    var page = 1
    var enableLoadMore = false
    
    @MainActor func preLoadMore(_ index: Int) {
        if index == paymentHistory.count - 1,
           enableLoadMore,
           !showProgressView {
            fetchPaymentHistory(true)
        }
    }
    
    @MainActor func fetchPaymentHistory(_ loadMore: Bool = false) {
        showProgressView = true
        
        if loadMore {
            if enableLoadMore {
                page += 1
            } else {
                showProgressView = false
                return
            }
        } else {
            page = 1
        }
        
        ServiceManager.shared.fetchPaymentHistory(page: page)
            .subscribe(onSuccess: { [weak self] response in
                guard let strongSelf = self else { return }
                strongSelf.showProgressView = false
                if let result = response.result {
                    let paymentList = result.rows
                    if loadMore {
                        strongSelf.paymentHistory += paymentList
                    } else {
                        strongSelf.paymentHistory = paymentList
                        
                        if CGFloat(paymentList.count * 65) < Constant.Board.Map.heightScreen {
                            self?.fetchPaymentHistory(true)
                        }
                    }
                    
                    strongSelf.enableLoadMore = (result.rows.count >= result.limit) && (strongSelf.page <= result.totalPages) && (strongSelf.paymentHistory.count < result.totalResults)
                }
            }, onFailure: { [weak self]  error in
                if let errorAPI = error as? AppAPIError {
                    self?.error = errorAPI
                    self?.showAlert = true
                }
                self?.showProgressView = false
            })
            .disposed(by: disposedBag)
    }
}
