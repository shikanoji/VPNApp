//
//  APIResponse.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 16/02/2022.
//

import Foundation
import SwiftyJSON

struct APIResponse: Decodable {
    var success: Bool
    var message: String
    var errors: Any
    var result: Any
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case errors = "errors"
        case result = "result"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decode(Bool.self, forKey: .success)
        message = try values.decode(String.self, forKey: .message)
        let _errors = try values.decode([Any].self, forKey: .errors)
        errors = JSON(_errors)
        let _result = try values.decode([Any].self, forKey: .result) 
        result = JSON(_result)
    }
}
