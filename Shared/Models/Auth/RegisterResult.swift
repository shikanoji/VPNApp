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
    
    init(user: User = User(), tokens: Tokens = Tokens()) {
        self.user = user
        self.tokens = tokens
    }
}
