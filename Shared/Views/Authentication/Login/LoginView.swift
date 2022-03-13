//
//  LoginView.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 09/12/2021.
//

import SwiftUI
import AuthenticationServices
import ExytePopupView

struct LoginView: View {
    @StateObject var viewModel: LoginViewModel
    @EnvironmentObject var authentication: Authentication
    @State var createNewAccount: Bool = false
    @State var forgotPassword: Bool = false
    
    var body: some View {
        ZStack {
            Background() {
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(alignment: .center) {
                                Spacer().frame(height: 100)
                                Asset.Assets.logoMedium.SuImage
                                Group{
                                    Spacer().frame(height: 50)
                                    Text(LocalizedStringKey.Login.title.localized).setTitle()
                                    Spacer().frame(height: 20)
                                    Text(LocalizedStringKey.Login.body.localized).setDefault()
                                    Spacer().frame(height: 40)
                                }
                                
                                Group{
                                    Form(placeholder: LocalizedStringKey.Login.emailPlaceholder.localized, value: $viewModel.email)
                                    Spacer().frame(height: 20)
                                    Form(placeholder: LocalizedStringKey.Login.passwordPlaceholder.localized, value: $viewModel.password, isPassword: true)
                                    Spacer().frame(height: 20)
                                    if viewModel.showProgressView {
                                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                                    }
                                    Spacer().frame(height: 20)
                                }
                                
                                Group {
                                    AppButton(style: .themeButton, width: 311, text: LocalizedStringKey.Login.signin.localized) {
                                        viewModel.login() {result in
                                            
                                        }
                                    }.disabled(viewModel.loginDisable)
                                    Spacer().frame(height: 30)
                                    AppButton(style: .darkButton, width: 311, text: LocalizedStringKey.Login.signinWithGoogle.localized, icon: Asset.Assets.google.SuImage) {
                                        viewModel.loginGoogle()
                                    }
                                    Spacer().frame(height: 10)
                                    AppButton(style: .darkButton, width: 311, text: LocalizedStringKey.Login.signinWithApple.localized, icon: Asset.Assets.apple.SuImage) {
                                        viewModel.loginApple()
                                    }
                                    Spacer().frame(height: 30)
                                }
                                Group {
                                    HStack(spacing: 2){
                                        Text(LocalizedStringKey.Login.noAccountQuestion.localized).setDefault()
                                        NavigationLink(destination: RegisterView(viewModel: RegisterViewModel()), isActive: $createNewAccount) {
                                            Text(LocalizedStringKey.Login.createNew.localized).setDefaultBold()
                                                .onTapGesture {
                                                    self.createNewAccount = true
                                                }
                                        }
                                        
                                    }
                                    Spacer().frame(height: 20)
                                    NavigationLink(destination: ForgotPasswordView(viewModel: ForgotPasswordViewModel()), isActive: $forgotPassword) {
                                    }
                                    Text(LocalizedStringKey.Login.forgotPassword.localized).setDefault().onTapGesture {
                                        //Handle Forgot Password
                                        self.forgotPassword = true
                                    }
                                }
                                Spacer().frame(height: 50)
                            }
                            .autocapitalization(.none)
                            .disabled(viewModel.showProgressView)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }.onAppear {
                        /// Pass authentication to view model because Environment object only receivable through view
                        viewModel.authentication = authentication
                    }
        }.popup(isPresented: $viewModel.showAlert, type: .floater(verticalPadding: 10), position: .bottom, animation: .easeInOut, autohideIn: 10, closeOnTap: false, closeOnTapOutside: true) {
            ToastView(title: viewModel.alertTitle,
                  message: viewModel.alertMessage,
                  cancelAction: {
                    viewModel.showAlert = false
                    })
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
