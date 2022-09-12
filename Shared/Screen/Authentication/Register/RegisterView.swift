//
//  RegisterView.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 09/12/2021.
//

import SwiftUI
import PopupView

struct RegisterView: View {
    @StateObject var viewModel: RegisterViewModel
    @State var toPlanSelection: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var authentication: Authentication
    @State var shouldPushLoginView: Bool = false
    var normalRegisterButton: some View {
        AppButton(style: .themeButton, width: Constant.Global.widthFormAndButton, text: L10n.Register.signup) {
            viewModel.signup()
        }
    }
    
    var header: some View {
        Group{
            Spacer().frame(height: 50)
            Text(L10n.Register.title).setTitle()
            Spacer().frame(height: 20)
            Text(L10n.Register.body).setDefault()
            Spacer().frame(height: 40)
        }
    }
    
    var forms: some View {
        Group{
            Form(placeholder: L10n.Register.emailPlaceholder, value: $viewModel.email, width: Constant.Global.widthFormAndButton)
            Spacer().frame(height: 20)
            Form(placeholder: L10n.Register.passwordPlaceholder, value: $viewModel.password, isPassword: true, width: Constant.Global.widthFormAndButton)
            Spacer().frame(height: 20)
            Form(placeholder: L10n.Register.retypePassword, value: $viewModel.retypePassword, isPassword: true, width: Constant.Global.widthFormAndButton)
            Spacer().frame(height: 20)
            if viewModel.showProgressView {
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white))
            }
            Spacer().frame(height: 20)
        }
    }
    
    var registerButtons: some View {
        Group {
            NavigationLink(destination: SubscriptionIntroduction()
                                            .navigationBarHidden(true),
                           isActive: $toPlanSelection) {
            }
            normalRegisterButton
            Spacer().frame(height: 30)
            AppButton(style: .darkButton, width: Constant.Global.widthFormAndButton, text: L10n.Register.signupWithGoogle, icon: Asset.Assets.google.swiftUIImage) {
                viewModel.signupGoogle()
            }
            Spacer().frame(height: 10)
            AppButton(style: .darkButton, width: Constant.Global.widthFormAndButton, text: L10n.Register.signupWithApple, icon: Asset.Assets.apple.swiftUIImage) {
                viewModel.signupApple()
            }
            Spacer().frame(height: 30)
        }
    }
    
    var backToLoginLink: some View {
        Group {
            HStack{
                Text(L10n.Register.hadAccountText).setDefault()
                Spacer().frame(width: 5)
                Text(L10n.Register.signin).setDefaultBold().onTapGesture {
                    if authentication.needToShowRegisterScreenBeforeLogin {
                        shouldPushLoginView = true
                    } else {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                NavigationLink(destination: LoginView(viewModel: LoginViewModel()), isActive: $shouldPushLoginView) {
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            Background() {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .center) {
                        Spacer().frame(minHeight: 100)
                        Asset.Assets.logoMedium.swiftUIImage
                        header
                        forms
                        registerButtons
                        backToLoginLink
                        Spacer().frame(minHeight: 100)
                    }
                    .frame(minHeight: UIScreen.main.bounds.height)
                    .autocapitalization(.none)
                    .disabled(viewModel.showProgressView)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            /// Pass authentication to view model because Environment object only receivable through view
            viewModel.authentication = authentication
        }
        .popup(isPresented: $viewModel.showAlert,
               type: .floater(verticalPadding: 10),
               position: .bottom,
               animation: .easeInOut,
               autohideIn: 10,
               closeOnTap: false,
               closeOnTapOutside: true) {
            PopupSelectView(message: viewModel.alertMessage,
                            confirmAction: {
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
