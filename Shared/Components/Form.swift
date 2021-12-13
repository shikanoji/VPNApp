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

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                if isPassword {
                    SecureField(placeholder, text: $value)
                } else {
                    TextField(placeholder, text: $value)
                }
            }
            .padding(.leading, 20)
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
        .frame(width: 311, height: 50)
        .background(AppColor.gray)
        .cornerRadius(5)
    }
}

