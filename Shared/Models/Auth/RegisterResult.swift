//
//  RegisterResult.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 17/02/2022.
//

import Foundation
import SwiftyJSON

class RegisterResultModel: ObservableObject, Decodable {
    var user: User
    var tokens: Tokens 
    
    enum CodingKeys: String, CodingKey {
        case user = "user"
        case tokens = "tokens"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user = try values.decode(User.self, forKey: .user)
        tokens = try values.decode(Tokens.self, forKey: .tokens)
    }
    
    init(user: User = User(), tokens: Tokens = Tokens()) {
        self.user = user
        self.tokens = tokens
    }
}
