//
//  RegisterView.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 09/12/2021.
//

import SwiftUI
import ExytePopupView

struct RegisterView: View {
    @StateObject var viewModel: RegisterViewModel
    @StateObject var registerResult: RegisterResultModel = RegisterResultModel()
    @State var toPlanSelection: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            Background() {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .center) {
                        Spacer().frame(height: 100)
                        Asset.Assets.logoMedium.SuImage
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
                            AppButton(style: .darkButton, width: 311, text: LocalizedStringKey.Register.signupWithGoogle.localized, icon: Asset.Assets.google.SuImage) {
                                viewModel.signupGoogle()
                            }
                            Spacer().frame(height: 10)
                            AppButton(style: .darkButton, width: 311, text: LocalizedStringKey.Register.signupWithApple.localized, icon: Asset.Assets.apple.SuImage) {
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
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }.environmentObject(registerResult)
        }
        .popup(isPresented: $viewModel.showAlert, type: .floater(verticalPadding: 10), position: .bottom, animation: .easeInOut, autohideIn: 10, closeOnTap: false, closeOnTapOutside: true) {
            ToastView(title: viewModel.alertTitle,
                  message: viewModel.alertMessage,
                  cancelAction: {
                viewModel.showAlert = false
            })
        }
    }
}
#if DEBUG
struct RegisterView_Preview: PreviewProvider {
    static var previews: some View {
        RegisterView(viewModel: RegisterViewModel())
    }
}
#endif
