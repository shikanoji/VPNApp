//
//  StatusResult.swift
//  SysVPN
//
//  Created by Da Phan Van on 23/09/2022.
//

import Foundation

struct StatusResult: Decodable {
    var score: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case score
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let _value = try? values.decode(Int.self, forKey: .score) {
            score = _value
        } else {
            score = 0
        }
    }
}
