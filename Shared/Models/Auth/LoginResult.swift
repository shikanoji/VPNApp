//
//  LoginResult.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 16/02/2022.
//

import Foundation
import SwiftyJSON

struct LoginResultModel: Decodable {
    var user: User
    var tokens: Tokens
    
    func convertToRegisterModel() -> RegisterResultModel {
        return RegisterResultModel(user: user, tokens: tokens)
    }
}

struct Tokens: Decodable {
    var access: Token
    var refresh: Token

    init(accessToken: Token = Token(), refreshToken: Token = Token()) {
        self.access = accessToken
        self.refresh = refreshToken
    }
}

struct Token: Decodable {
    init(token: String = "", expires: Int? = nil) {
        self.token = token
        self.expires = expires
    }
    
    var token: String
    var expires: Int?
}

struct User: Decodable {
    init(id: Int64 = 0,
         created_at: Int? = nil,
         updated_at: Int? = nil,
         email: String = "",
         password: String = "",
         premiumExpire: Int? = nil,
         isPremium: Bool = false,
         name: String? = nil,
         has_password: Bool = true) {
        self.id = id
        self.created_at = created_at
        self.updated_at = updated_at
        self.email = email
        self.password = password
        self.premium_expire = premiumExpire
        self.is_premium = isPremium
        self.name = name
        self.has_password = has_password
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case created_at = "created_at"
        case email = "email"
        case updated_at = "updated_at"
        case password = "password"
        case premium_expire = "premium_expire"
        case is_premium = "is_premium"
        case name = "name"
        case has_password = "has_password"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int64.self, forKey: .id)
        if values.contains(.created_at) {
            created_at = try values.decode(Int.self, forKey: .created_at)
        }
        email = try values.decode(String.self, forKey: .email)
        if values.contains(.premium_expire) {
            premium_expire = try values.decode(Int?.self, forKey: .premium_expire)
        }
        if values.contains(.is_premium) {
            is_premium = try values.decode(Bool.self, forKey: .is_premium)
        }
        if values.contains(.name) {
            name = try values.decode(String?.self, forKey: .name)
        }
        if values.contains(.updated_at) {
            updated_at = try values.decode(Int.self, forKey: .updated_at)
        }
        if values.contains(.password) {
            password = try values.decode(String.self, forKey: .password)
        }
        if values.contains(.has_password) {
            has_password = try values.decode(Bool.self, forKey: .has_password)
        }
    }
    
    var id: Int64 = 0
    var created_at: Int? = nil
    var updated_at: Int? = nil
    var email: String = ""
    var password: String = ""
    var name: String? = nil
    var is_premium: Bool = false
    var premium_expire: Int? = nil
    var has_password: Bool = true
}
