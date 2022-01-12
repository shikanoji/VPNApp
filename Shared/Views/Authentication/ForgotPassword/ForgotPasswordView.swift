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
    
    var body: some View {
        Background() {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center) {
                    Spacer().frame(height: 100)
                    Image("Logo-medium")
                    Group{
                        Spacer().frame(height: 50)
                        Text(LocalizedStringKey.ForgotPassword.title.localized).setTitle()
                        Spacer().frame(height: 20)
                        Text(LocalizedStringKey.ForgotPassword.body.localized).setDefault()
                        Spacer().frame(height: 40)
                    }
                    
                    Group{
                        Form(placeholder: LocalizedStringKey.ForgotPassword.emailPlaceholder.localized, value: $viewModel.email)
                        Spacer().frame(height: 20)
                    }
                    
                    Group {
                        AppButton(style: .themeButton, width: 311, text: LocalizedStringKey.ForgotPassword.sendRequestButton.localized) {
                            viewModel.sendRequest()
                        }
                    }.disabled(viewModel.sendRequestDisable)
                    Spacer().frame(height: 30)
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

#if DEBUG
struct ForgotPasswordView_Preview: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView(viewModel: ForgotPasswordViewModel())
    }
}
#endif
