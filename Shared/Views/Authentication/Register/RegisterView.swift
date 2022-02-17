//
//  RegisterView.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 09/12/2021.
//

import Foundation
import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel: RegisterViewModel
    @StateObject var registerResult: RegisterResultModel = RegisterResultModel()
    @State var toPlanSelection: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        Background() {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center) {
                    Spacer().frame(height: 100)
                    Image("Logo-medium")
                    Group{
                        Spacer().frame(height: 50)
                        Text(LocalizedStringKey.Register.title.localized).setTitle()
                        Spacer().frame(height: 20)
                        Text(LocalizedStringKey.Register.body.localized).setDefault()
                        Spacer().frame(height: 40)
                    }
                    
                    Group{
                        Form(placeholder: LocalizedStringKey.Register.emailPlaceholder.localized, value: $viewModel.email)
                        Spacer().frame(height: 20)
                        Form(placeholder: LocalizedStringKey.Register.passwordPlaceholder.localized, value: $viewModel.password, isPassword: true)
                        Spacer().frame(height: 20)
                        Form(placeholder: LocalizedStringKey.Register.retypePassword.localized, value: $viewModel.retypePassword, isPassword: true)
                        Spacer().frame(height: 20)
                        if viewModel.showProgressView {
                            ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        }
                        Spacer().frame(height: 20)
                    }
                    
                    Group {
                        NavigationLink(destination: SubscriptionIntroduction().environmentObject(registerResult), isActive: $toPlanSelection) {
                        }
                        AppButton(style: .themeButton, width: 311, text: LocalizedStringKey.Register.signup.localized) {
                            viewModel.signup(){ result, register in
                                if result == .success, let  _register = register {
                                    registerResult.user = _register.user
                                    registerResult.tokens = _register.tokens
                                    toPlanSelection = true
                                }
                            }
                        }.disabled(viewModel.registerDisable)
                        Spacer().frame(height: 30)
                        AppButton(style: .darkButton, width: 311, text: LocalizedStringKey.Register.signupWithGoogle.localized, icon: Image("google")) {
                            viewModel.signupGoogle()
                        }
                        Spacer().frame(height: 10)
                        AppButton(style: .darkButton, width: 311, text: LocalizedStringKey.Register.signupWithApple.localized, icon: Image("apple")) {
                            viewModel.signupApple()
                        }
                        Spacer().frame(height: 30)
                    }
                    Group {
                        HStack{
                            Text(LocalizedStringKey.Register.hadAccountText.localized).setDefault()
                            Spacer().frame(width: 5)
                            Text(LocalizedStringKey.Register.signin.localized).setDefaultBold().onTapGesture {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                    Spacer().frame(height: 50)
                }
                .autocapitalization(.none)
                .disabled(viewModel.showProgressView)
                .onReceiveAlert(title: $viewModel.alertTitle, message: $viewModel.alertMessage, showing: $viewModel.showAlert)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }.environmentObject(registerResult)
    }
}
#if DEBUG
struct RegisterView_Preview: PreviewProvider {
    static var previews: some View {
        RegisterView(viewModel: RegisterViewModel())
    }
}
#endif
