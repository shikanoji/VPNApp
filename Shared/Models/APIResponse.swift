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
    var code: Int?

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case errors = "errors"
        case result = "result"
        case code = "code"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decode(Bool.self, forKey: .success)
        if let _message = try? values.decode(String.self, forKey: .message) {
            message = _message
        } else {
            message = ""
        }
        if let _errors = try? values.decode([Any].self, forKey: .errors) {
            errors = _errors
        } else {
            errors = []
        }

        if let _result = try? values.decode(T?.self, forKey: .result) {
            result = _result
        } else {
            result = nil
        }

        if let value = try? values.decode(Int.self, forKey: .code) {
            code = value
        } else {
            code = nil
        }
    }
}
