//
//  RegisterView.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 09/12/2021.
//

import SwiftUI
import PopupView

struct RegisterView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var authentication: Authentication
    @StateObject var viewModel: RegisterViewModel
    @State var toPlanSelection: Bool = false
    @State var shouldPushLoginView: Bool = false

    var normalRegisterButton: some View {
        AppButton(style: .themeButton, width: Constant.Global.widthFormAndButton, text: L10n.Register.signup) {
            viewModel.signup()
        }
    }

    private let textFieldSpacing: CGFloat = 20
    private let buttonSpacing: CGFloat = 30
    private let minTopSpacing: CGFloat = 100

    var header: some View {
        Group {
            Spacer().frame(height: 50)
            Text(L10n.Register.title).setTitle()
            Spacer().frame(height: textFieldSpacing)
            Text(L10n.Register.body).setDefault()
            Spacer().frame(height: 40)
        }
    }
    
    var textInputs: some View {
        Group {
            Form(placeholder: L10n.Register.emailPlaceholder, value: $viewModel.email, width: Constant.Global.widthFormAndButton)
            Spacer().frame(height: textFieldSpacing)
            Form(placeholder: L10n.Register.passwordPlaceholder, value: $viewModel.password, isPassword: true, width: Constant.Global.widthFormAndButton)
            Spacer().frame(height: textFieldSpacing)
            Form(placeholder: L10n.Register.retypePassword, value: $viewModel.retypePassword, isPassword: true, width: Constant.Global.widthFormAndButton)
            Spacer().frame(height: textFieldSpacing)
        }
    }
    
    var registerButtons: some View {
        Group {
            NavigationLink(destination: SubscriptionIntroduction()
                .navigationBarHidden(true),
                isActive: $toPlanSelection) {
                }
            normalRegisterButton
            Spacer().frame(height: buttonSpacing)
            AppButton(style: .darkButton, width: Constant.Global.widthFormAndButton, text: L10n.Register.signupWithGoogle, icon: Asset.Assets.google.swiftUIImage) {
                viewModel.signupGoogle()
            }
            Spacer().frame(height: 10)
            AppButton(style: .darkButton, width: Constant.Global.widthFormAndButton, text: L10n.Register.signupWithApple, icon: Asset.Assets.apple.swiftUIImage) {
                viewModel.signupApple()
            }
            Spacer().frame(height: buttonSpacing)
        }
    }
    
    var backToLoginLink: some View {
        Group {
            HStack {
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
        LoadingScreen(isShowing: $viewModel.showProgressView) {
            Background() {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .center) {
                        Spacer().frame(minHeight: minTopSpacing)
                        Asset.Assets.logoMedium.swiftUIImage
                        header
                        textInputs
                        registerButtons
                        backToLoginLink
                        Spacer().frame(minHeight: minTopSpacing)
                    }
                    .frame(minHeight: UIScreen.main.bounds.height)
                    .autocapitalization(.none)
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
               autohideIn: 5,
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
