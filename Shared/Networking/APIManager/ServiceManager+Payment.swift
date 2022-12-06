//
//  ServiceManager+Payment.swift
//  SysVPN
//
//  Created by Nguyen Dinh Thach on 17/07/2022.
//

import Moya
import RxMoya
import RxSwift
import SwiftyJSON

extension ServiceManager {
    func fetchPaymentHistory(page: Int) -> Single<APIResponse<PaymentHistory>> {
        return request(.fetchPaymentHistory(page: page))
            .map { response in
                let paymentHistory = try JSONDecoder().decode(APIResponse<PaymentHistory>.self, from: response.data)
                return paymentHistory
            }
            .catch { error in
                throw AppAPIError.someError
            }
    }

    func verifyReceipt(receiptString: String) -> Single<APIResponse<User>> {
        return request(.verifyReceipt(receipt: receiptString))
            .map { response in
                let verifyResult = try JSONDecoder().decode(APIResponse<User>.self, from: response.data)
                return verifyResult
            }
            .catch { error in
                throw AppAPIError.someError
            }
    }
}
