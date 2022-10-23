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
    let shouldAnimate: Bool
    var width: CGFloat
    
    init(placeholder: String = "", value: Binding<String>, isPassword: Bool = false, shouldAnimate: Bool = true, width: CGFloat = 311) {
        self.placeholder = placeholder
        _value = value
        self.isPassword = isPassword
        isRevealed = !self.isPassword
        isFocused = false
        self.shouldAnimate = shouldAnimate
        self.width = width
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
        .frame(width: width, height: 50)
        .background(Color.clear)
        .overlay(isFocused ? RoundedRectangle(cornerRadius: 5).stroke(Color.white.opacity(0.8), lineWidth: 3) : RoundedRectangle(cornerRadius: 5).stroke(Color.white.opacity(0.2), lineWidth: 3))
        .cornerRadius(5)
        .animation(shouldAnimate ? .spring(response: 0.4,
                                           dampingFraction: 1, blendDuration: 0) : nil)
    }
}

