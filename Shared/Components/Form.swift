//
//  Form.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 13/12/2021.
//

import Foundation
import SwiftUI
import RxSwift

struct Form: View {
    var placeholder: String
    @Binding var value: String
    var isPassword: Bool = false
    @State private var isRevealed: Bool
    @State private var isFocused: Bool
    
    init(placeholder: String = "", value: Binding<String>, isPassword: Bool = false){
        self.placeholder = placeholder
        _value = value
        self.isPassword = isPassword
        isRevealed = !self.isPassword
        isFocused = false
    }
    
    var body: some View {
        VStack {
            if isPassword {
                PasswordField(text: $value, isRevealed: $isRevealed, isFocused: $isFocused, placeholder: placeholder)
            } else {
                AppTextField(text: $value, isRevealed: $isRevealed, isFocused: $isFocused, placeholder: placeholder)
            }
        }
        .padding()
        .frame(width: 311, height: 50)
        .background(Color.clear)
        .overlay(isFocused ? RoundedRectangle(cornerRadius: 5).stroke(Color.white.opacity(0.8), lineWidth: 3) : RoundedRectangle(cornerRadius: 5).stroke(Color.white.opacity(0.2), lineWidth: 3))
        .cornerRadius(5)
        .animation(Animation.interpolatingSpring(stiffness: 50, damping: 15))
    }
}

