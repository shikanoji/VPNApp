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
    
    let token: String
    let expires: String
}

struct User: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case created_at = "created_at"
        case email = "email"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int64.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        created_at = try values.decode(Int64.self, forKey: .created_at)
        email = try values.decode(String.self, forKey: .email)
    }
    
    let id: Int64
    let name: String
    let created_at: Int64
    let email: String
}
