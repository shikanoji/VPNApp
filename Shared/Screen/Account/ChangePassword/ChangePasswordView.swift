//
//  ChangePasswordView.swift
//  SysVPN
//
//  Created by Da Phan Van on 17/01/2022.
//

import SwiftUI
import Combine

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

struct ChangePasswordView: View {
    @StateObject var viewModel: ChangePasswordViewModel
    @Binding var showChangePassword: Bool
    @State private var keyboardHeight: CGFloat = 0
    
    var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(AppSetting.shared.hasPassword ? L10n.Account.Infomation.changePassword : L10n.Account.Infomation.setPassword)
                .font(Constant.ChangePassWord.fontTitle)
            Text(AppSetting.shared.hasPassword ? L10n.Account.Infomation.introChangePassword : L10n.Account.Infomation.setPasswordNote)
                .font(Constant.ChangePassWord.fontSubContent)
                .foregroundColor(Asset.Colors.lightBlackText.swiftUIColor)
        }
        .padding(.vertical)
    }
    
    var passwordForms: some View {
        VStack {
            if AppSetting.shared.hasPassword {
                Form(placeholder: L10n.Account.Infomation.currentPassword,
                     value: $viewModel.password,
                     isPassword: true,
                     shouldAnimate: false)
                Spacer().frame(height: 16)
            }
            Form(placeholder: L10n.Account.Infomation.newPassword,
                 value: $viewModel.newPassword,
                 isPassword: true,
                 shouldAnimate: false)
            Spacer().frame(height: 16)
            Form(placeholder: L10n.Account.Infomation.retypePassword,
                 value: $viewModel.retypePassword,
                 isPassword: true,
                 shouldAnimate: false)
            Spacer().frame(height: 16)
        }
    }
    
    var submitButton: some View {
        AppButton(style: .themeButton, width: 311, text: L10n.Account.Infomation.save) {
            viewModel.changePassword()
        }
    }
    
    var content: some View {
        VStack(alignment: .leading) {
            Spacer().frame(height: 20)
            header
            passwordForms
            Spacer().frame(height: 20)
            submitButton
            Spacer().frame(height: 40)
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .background(AppColor.darkButton)
        .cornerRadius(radius: Constant.Menu.radiusCell * 2, corners: [PositionItemCell.top.rectCorner])
        .padding(.top, -Constant.Menu.radiusCell * 2)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    VisualEffectView(effect: UIBlurEffect(style: .dark))
                        .opacity(0.95)
                        .onTapGesture {
                            self.showChangePassword = false
                        }
                    HStack {
                        Image(Constant.CustomNavigation.iconBack)
                            .onTapGesture {
                                self.showChangePassword = false
                            }
                        Spacer()
                    }
                    .padding(.top, 35.0)
                }
                content
                Spacer().frame(height: keyboardHeight)
            }
            if viewModel.showProgressView {
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
        .popup(isPresented: $viewModel.showAlert,
               type: .floater(verticalPadding: 10),
               position: .bottom,
               animation: .easeInOut,
               autohideIn: 10,
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

struct ChangePasswordView_Previews: PreviewProvider {
    @State static var showChangePassword = true
    
    static var previews: some View {
        ChangePasswordView(viewModel: ChangePasswordViewModel(), showChangePassword: $showChangePassword)
    }
}
