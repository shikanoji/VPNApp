//
//  LoginView.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 09/12/2021.
//

import Foundation
import SwiftUI
struct LoginView: View {
    @State var username: String = ""
    @State var password: String = ""
    var body: some View {
        GeometryReader{ geometry in
            VStack(alignment: .center) {
                Spacer().frame(height: 80)
                Form(placeholder: "Your username", value: $username, isPassword: false)
                Spacer().frame(height: 20)
                Form(placeholder: "Your password", value: $password, isPassword: true)
                Spacer().frame(height: 80)
                AppButton(style: .themeButton, width: 200, text: "Sign In") {
                    print("Sign In")
                }
                Spacer()
            }.frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}
#if DEBUG
struct LoginView_Preview: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
#endif
