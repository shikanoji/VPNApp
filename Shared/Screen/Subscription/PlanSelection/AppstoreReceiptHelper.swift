//
//  AppstoreReceiptHelper.swift
//  SysVPN
//
//  Created by Nguyen Dinh Thach on 29/07/2022.
//

import Foundation
import RxSwift
final class AppstoreReceiptHelper {
    static var shared: AppstoreReceiptHelper = AppstoreReceiptHelper()
    var disposedBag: DisposeBag = DisposeBag()
    
    @MainActor
    func verifyReceipt() async -> Result<APIResponse<User>, Error> {
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
           FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
            do {
                let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                
                let receiptString = receiptData.base64EncodedString(options: [])
                return await withCheckedContinuation
                { (continuation: CheckedContinuation<Result<APIResponse<User>, Error>, Never>) in
                    ServiceManager.shared.verifyReceipt(receiptString: receiptString)
                        .subscribe(onSuccess: { result in
                            continuation.resume(returning: .success(result))
                        }, onFailure: { error in
                            continuation.resume(returning: .failure(error))
                        })
                        .disposed(by: disposedBag)
                }
            }
            catch {
                return .failure(error)
            }
        } else {
            return .failure(APIError.someError)
        }
    }
}
