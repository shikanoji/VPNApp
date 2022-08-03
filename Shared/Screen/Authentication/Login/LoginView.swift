//
//  LoginView.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 09/12/2021.
//

import SwiftUI
import AuthenticationServices
import PopupView

struct LoginView: View {
    @StateObject var viewModel: LoginViewModel
    @EnvironmentObject var authentication: Authentication
    @State var createNewAccount: Bool = false
    @State var forgotPassword: Bool = false
    @State var toPlanSelection: Bool = false
    
    var header: some View {
        VStack {
            Asset.Assets.logoMedium.SuImage
            Spacer().frame(height: 50)
            Text(L10n.Login.title).setTitle()
            Spacer().frame(height: 20)
            Text(L10n.Login.body).setDefault()
            Spacer().frame(height: 40)
        }
    }
    
    var forms: some View {
        ZStack {
            VStack {
                Form(placeholder: L10n.Login.emailPlaceholder, value: $viewModel.email)
                Spacer().frame(height: 20)
                Form(placeholder: L10n.Login.passwordPlaceholder, value: $viewModel.password, isPassword: true)
                Spacer().frame(height: 20)
                Spacer().frame(height: 20)
            }
            if viewModel.showProgressView {
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white))
            }
        }
    }
    
    var loginButton: some View {
        AppButton(style: .themeButton, width: 311, text: L10n.Login.signin) {
            viewModel.fullLogin()
        }.disabled(viewModel.loginDisable)
    }
    
    var loginWithGoogleButton: some View {
        AppButton(style: .darkButton, width: 311, text: L10n.Login.signinWithGoogle, icon: Asset.Assets.google.SuImage) {
            viewModel.loginGoogle()
        }
    }
    
    var loginWithAppleButton: some View {
        AppButton(style: .darkButton, width: 311, text: L10n.Login.signinWithApple, icon: Asset.Assets.apple.SuImage) {
            viewModel.loginApple()
        }
    }
    
    var registerLink: some View {
        HStack(spacing: 2){
            Text(L10n.Login.noAccountQuestion).setDefault()
            NavigationLink(destination: RegisterView(viewModel: RegisterViewModel()), isActive: $createNewAccount) {
                Text(L10n.Login.createNew).setDefaultBold()
                    .onTapGesture {
                        self.createNewAccount = true
                    }
            }
        }
    }
    
    var forgotPasswordLink: some View {
        VStack {
            NavigationLink(destination: ForgotPasswordView(viewModel: ForgotPasswordViewModel()), isActive: $forgotPassword) {
            }
            Text(L10n.Login.forgotPassword).setDefault().onTapGesture {
                //Handle Forgot Password
                self.forgotPassword = true
            }
        }
    }
    
    var body: some View {
        ZStack {
            Background() {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .center) {
                        Spacer().frame(minHeight: 100)
                        header
                        forms
                        Group {
                            loginButton
                            Spacer().frame(height: 30)
                            loginWithGoogleButton
                            Spacer().frame(height: 10)
                            loginWithAppleButton
                            Spacer().frame(height: 30)
                        }
                        Group {
                            registerLink
                            Spacer().frame(height: 20)
                            forgotPasswordLink
                        }
                        Spacer().frame(minHeight: 100)
                    }
                    .frame(minHeight: UIScreen.main.bounds.height)
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
