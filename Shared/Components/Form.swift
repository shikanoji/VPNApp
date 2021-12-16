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
    var placeholder: String = ""
    @Binding var value: String
    var isPassword: Bool = false
    @State private var isRevealed: Bool
    @State private var isFocused = false
    
    init(placeholder: String, value: Binding<String>, isPassword: Bool = false){
        self.placeholder = placeholder
        _value = value
        self.isPassword = isPassword
        isRevealed = !self.isPassword
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                if isPassword {
                    PasswordField(text: $value, isRevealed: $isRevealed, isFocused: $isFocused, placeholder: placeholder)
                } else {
                    AppTextField(text: $value, isRevealed: $isRevealed, isFocused: $isFocused, placeholder: placeholder)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
        .padding()
        .frame(width: 311, height: 50)
        .background(isFocused ? Color.white : AppColor.gray)
        .cornerRadius(5)
        .overlay(isFocused ? RoundedRectangle(cornerRadius: 5).stroke(AppColor.blue, lineWidth:2) : nil)
    }
}

