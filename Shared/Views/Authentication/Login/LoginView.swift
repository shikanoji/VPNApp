//
//  LoginView.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 09/12/2021.
//

import Foundation
import SwiftUI
struct LoginView: View {
    @StateObject var viewModel: LoginViewModel
    @EnvironmentObject var authentication: Authentication
    var body: some View {
        GeometryReader{ geometry in
            Background() {
                VStack() {
                    Spacer()
                    
                    Form(placeholder: "Your username", value: $viewModel.username)
                    Spacer().frame(height: 20)
                    Form(placeholder: "Your password", value: $viewModel.password, isPassword: true)
                    Spacer().frame(height: 80)
                    if viewModel.showProgressView {
                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    }
                    Spacer().frame(height: 20)
                    AppButton(style: .themeButton, width: 311, text: "Sign In") {
                        viewModel.login() {result in
                            if result == .success {
                                authentication.updateValidation(success: true)
                            }
                        }
                    }.disabled(viewModel.loginDisable)
                    Spacer()
                }
                .autocapitalization(.none)
                .disabled(viewModel.showProgressView)
                .onReceiveAlertWithAction(title: $viewModel.alertTitle, message: $viewModel.alertMessage, showing: $viewModel.showAlert) {
                    //Handle Alert Confirmation
                }
            }.endEditingOnTappingOutside()
        }
        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    }
}
#if DEBUG
struct LoginView_Preview: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
#endif
