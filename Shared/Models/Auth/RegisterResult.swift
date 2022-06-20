//
//  RegisterResult.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 17/02/2022.
//

import Foundation
import SwiftyJSON

class RegisterResultModel: ObservableObject, Decodable, Equatable {
    static func == (lhs: RegisterResultModel, rhs: RegisterResultModel) -> Bool {
        lhs.user.id == rhs.user.id
    }
    
    var user: User
    var tokens: Tokens 
    
    init(user: User = User(), tokens: Tokens = Tokens()) {
        self.user = user
        self.tokens = tokens
    }
    
    func convertToLoginModel() -> LoginResultModel {
        return LoginResultModel(user: user, tokens: tokens)
    }
}
