//
//  PaymentHistory.swift
//  SysVPN
//
//  Created by Da Phan Van on 18/01/2022.
//

import Foundation
import SwiftUI

struct PaymentHistory {
    enum statusPayemnt {
        case failed
        case success
    }
    
    var id: UUID = UUID()
    var pack = "3 months pack"
    var status: statusPayemnt = .failed
    var contentStatus: String {
        switch status {
        case .failed:
            return "Failed"
        case .success:
            return "Success"
        }
    }
    var date = "20:22 20210-12-25"
    var cancel = false
}
