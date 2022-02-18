//
//  APIResponse.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 16/02/2022.
//

import Foundation
import SwiftyJSON

struct APIResponse<T: Decodable>: Decodable {
    var success: Bool
    var message: String
    var errors: [Any]
    var result: T?
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case errors = "errors"
        case result = "result"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decode(Bool.self, forKey: .success)
        if let _message = try? values.decode(String.self, forKey: .message) {
            self.message = _message
        } else {
            self.message = ""
        }
        if let _errors = try? values.decode([Any].self, forKey: .errors) {
            self.errors = _errors
        } else {
            self.errors = []
        }
        
        if let _result = try? values.decode(T?.self, forKey: .result) {
            result = _result
        } else {
            result = nil
        }
    }
}
