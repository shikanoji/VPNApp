//
//  ForgotPasswordView.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 28/12/2021.
//

import Foundation
import SwiftUI

struct ForgotPasswordView: View {
    @StateObject var viewModel: ForgotPasswordViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var header: some View {
        Group{
            Spacer().frame(height: 50)
            Text(L10n.ForgotPassword.title).setTitle()
            Spacer().frame(height: 20)
            Text(L10n.ForgotPassword.body).setDefault()
            Spacer().frame(height: 40)
        }
    }
    
    var emailForm: some View {
        Form(placeholder: L10n.ForgotPassword.emailPlaceholder, value: $viewModel.email)
    }
    
    var submitButton: some View {
        AppButton(style: .themeButton, width: 311, text: L10n.ForgotPassword.sendRequestButton) {
            viewModel.sendRequest()
        }.disabled(viewModel.sendRequestDisable)
    }
    
    var footer: some View {
        HStack{
            Text(L10n.Register.hadAccountText).setDefault()
            Spacer().frame(width: 5)
            Text(L10n.Register.signin).setDefaultBold().onTapGesture {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    var body: some View {
        Background() {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center) {
                    Spacer().frame(minHeight: 20)
                    Asset.Assets.logoMedium.swiftUIImage
                    header
                    emailForm
                    Spacer().frame(height: 20)
                    submitButton
                    Spacer().frame(height: 30)
                    footer
                    Spacer().frame(minHeight: 20)
                }
                .frame(minHeight: UIScreen.main.bounds.height)
            }
            .autocapitalization(.none)
            .disabled(viewModel.showProgressView)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .popup(isPresented: $viewModel.showAlert,
               type: .floater(verticalPadding: 10),
               position: .bottom,
               animation: .easeInOut,
               closeOnTap: false,
               closeOnTapOutside: true) {
            ToastView(title: viewModel.alertTitle,
                      message: viewModel.alertMessage,
                      cancelAction: {
                viewModel.showAlert = false
            })
        }
    }
}

#if DEBUG
struct ForgotPasswordView_Preview: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView(viewModel: ForgotPasswordViewModel())
    }
}
#endif
