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
        Background() {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center) {
                    Spacer().frame(height: 100)
                    Image("Logo-medium")
                    Group{
                        Spacer().frame(height: 50)
                        Text(LocalizedStringKey.Login.title.localized).setTitle()
                        Spacer().frame(height: 20)
                        Text(LocalizedStringKey.Login.body.localized).setDefault()
                        Spacer().frame(height: 40)
                    }
                    
                    Group{
                        Form(placeholder: "Your username", value: $viewModel.username)
                        Spacer().frame(height: 20)
                        Form(placeholder: "Your password", value: $viewModel.password, isPassword: true)
                        Spacer().frame(height: 20)
                        if viewModel.showProgressView {
                            ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        }
                        Spacer().frame(height: 20)
                    }
                    
                    Group {
                        AppButton(style: .themeButton, width: 311, text: "Sign In") {
                            viewModel.login() {result in
                                authentication.login(username: viewModel.username, password: viewModel.password)
                            }
                        }.disabled(viewModel.loginDisable)
                        Spacer().frame(height: 30)
                        AppButton(style: .darkButton, width: 311, text: "Sign In With Google") {
                        }
                        Spacer().frame(height: 10)
                        AppButton(style: .darkButton, width: 311, text: "Sign In With Apple") {
                        }
                        Spacer().frame(height: 30)
                    }
                    Group {
                        HStack{
                            Text("Don't have an account?").setDefault()
                            Spacer().frame(width: 5)
                            Text("Create new").setDefaultBold().onTapGesture {
                                //Handle Create new account
                            }
                        }
                        Spacer().frame(height: 20)
                        Text("Forgot Pasword?").setDefault().onTapGesture {
                            //Handle Forgot Password
                        }
                    }
                    Spacer()
                }
                .autocapitalization(.none)
                .disabled(viewModel.showProgressView)
                .onReceiveAlertWithAction(title: $viewModel.alertTitle, message: $viewModel.alertMessage, showing: $viewModel.showAlert) {
                    //Handle Alert Confirmation
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
#if DEBUG
struct LoginView_Preview: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
#endif
