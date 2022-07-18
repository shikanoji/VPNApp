//
//  PaymentHistoryResult.swift
//  SysVPN
//
//  Created by Nguyen Dinh Thach on 17/07/2022.
//

import Foundation
import SwiftDate

struct PaymentHistory: Decodable {
    var page: Int = 0
    var limit: Int = 0
    var totalPages: Int = 0
    var totalResults: Int = 0
    var rows: [PaymentHistoryRow] = []
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case limit = "limit"
        case totalPages = "totalPages"
        case totalResults = "totalResults"
        case rows = "rows"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if values.contains(.page) {
            page = try values.decode(Int.self, forKey: .page)
        }
        if values.contains(.limit) {
            limit = try values.decode(Int.self, forKey: .limit)
        }
        if values.contains(.totalPages) {
            totalPages = try values.decode(Int.self, forKey: .totalPages)
        }
        if values.contains(.totalResults) {
            totalResults = try values.decode(Int.self, forKey: .totalResults)
        }
        if values.contains(.rows) {
            rows = try values.decode([PaymentHistoryRow].self, forKey: .rows)
        }
    }
}

struct PaymentHistoryRow: Decodable {
    var status: String = ""
    var packageName: String = ""
    var paymentDate: String = ""
    
    enum CodingKeys: String, CodingKey {
        case packageName = "packageName"
        case paymentDate = "paymentDate"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if values.contains(.packageName) {
            packageName = try values.decode(String.self, forKey: .packageName)
        }
        
        if values.contains(.status) {
                    status = try values.decode(String.self, forKey: .status)
        }
        
        if values.contains(.paymentDate) {
            guard let date = try values.decode(Int?.self, forKey: .paymentDate) else { return }
            let expireInteval = TimeInterval(date)
            let expireDate = DateInRegion(seconds: expireInteval, region: .local)
            paymentDate = expireDate.toFormat("hh:mm:ss dd-MM-yyyy")
        }
        
    }
}
