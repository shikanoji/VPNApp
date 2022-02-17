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
    
    enum CodingKeys: String, CodingKey {
        case user = "user"
        case tokens = "tokens"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user = try values.decode(User.self, forKey: .user)
        tokens = try values.decode(Tokens.self, forKey: .tokens)
    }
}

struct Tokens: Decodable {
    var access: Token
    var refresh: Token
    enum CodingKeys: String, CodingKey {
        case access = "access"
        case refresh = "refresh"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        access = try values.decode(Token.self, forKey: .access)
        refresh = try values.decode(Token.self, forKey: .refresh)
    }
    
    init(accessToken: Token = Token(), refreshToken: Token = Token()) {
        self.access = accessToken
        self.refresh = refreshToken
    }
}

struct Token: Decodable {
    enum CodingKeys: String, CodingKey {
        case token = "token"
        case expires = "expires"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        token = try values.decode(String.self, forKey: .token)
        expires = try values.decode(String.self, forKey: .expires)
    }
    
    init(token: String = "", expires: String = "") {
        self.token = token
        self.expires = expires
    }
    
    var token: String
    var expires: String
}

struct User: Decodable {
    init(id: Int64 = 0, created_at: Int64 = 0, updated_at: Int64 = 0, email: String = "", password: String = "") {
        self.id = id
        self.created_at = created_at
        self.updated_at = updated_at
        self.email = email
        self.password = password
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case created_at = "created_at"
        case email = "email"
        case updated_at = "updated_at"
        case password = "password"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int64.self, forKey: .id)
        created_at = try values.decode(Int64.self, forKey: .created_at)
        email = try values.decode(String.self, forKey: .email)
        if values.contains(.updated_at) {
            updated_at = try values.decode(Int64.self, forKey: .updated_at)
        }
        if values.contains(.password) {
            password = try values.decode(String.self, forKey: .password)
        }
    }
    
    var id: Int64 = 0
    var created_at: Int64 = 0
    var updated_at: Int64 = 0
    var email: String = ""
    var password: String = ""
}
