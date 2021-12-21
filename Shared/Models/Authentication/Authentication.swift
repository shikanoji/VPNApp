//
//  Authentication.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 21/12/2021.
//

import Foundation
import SwiftUI
class Authentication: ObservableObject {
    @Published var isValidated = false
    
    func updateValidation(success: Bool) {
        withAnimation{
            isValidated = success
        }
    }
}
