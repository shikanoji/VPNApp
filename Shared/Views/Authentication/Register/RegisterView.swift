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
                            Text(L10n.Register.title).setTitle()
                            Spacer().frame(height: 20)
                            Text(L10n.Register.body).setDefault()
                            Spacer().frame(height: 40)
                        }
                        
                        Group{
                            Form(placeholder: L10n.Register.emailPlaceholder, value: $viewModel.email)
                            Spacer().frame(height: 20)
                            Form(placeholder: L10n.Register.passwordPlaceholder, value: $viewModel.password, isPassword: true)
                            Spacer().frame(height: 20)
                            Form(placeholder: L10n.Register.retypePassword, value: $viewModel.retypePassword, isPassword: true)
                            Spacer().frame(height: 20)
                            if viewModel.showProgressView {
                                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                            }
                            Spacer().frame(height: 20)
                        }
                        
                        Group {
                            NavigationLink(destination: SubscriptionIntroduction().environmentObject(registerResult), isActive: $toPlanSelection) {
                            }
                            AppButton(style: .themeButton, width: 311, text: L10n.Register.signup) {
                                viewModel.signup(){ result, register in
                                    if result == .success, let  _register = register {
                                        registerResult.user = _register.user
                                        registerResult.tokens = _register.tokens
                                        toPlanSelection = true
                                    }
                                }
                            }.disabled(viewModel.registerDisable)
                            Spacer().frame(height: 30)
                            AppButton(style: .darkButton, width: 311, text: L10n.Register.signupWithGoogle, icon: Asset.Assets.google.SuImage) {
                                viewModel.signupGoogle()
                            }
                            Spacer().frame(height: 10)
                            AppButton(style: .darkButton, width: 311, text: L10n.Register.signupWithApple, icon: Asset.Assets.apple.SuImage) {
                                viewModel.signupApple()
                            }
                            Spacer().frame(height: 30)
                        }
                        Group {
                            HStack{
                                Text(L10n.Register.hadAccountText).setDefault()
                                Spacer().frame(width: 5)
                                Text(L10n.Register.signin).setDefaultBold().onTapGesture {
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
