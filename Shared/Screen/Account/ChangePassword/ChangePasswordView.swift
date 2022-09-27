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
    
    var cancel: (() -> Void)? = nil
    
    var header: some View {
        HStack {
            Spacer().frame(width: 32)
            VStack(alignment: .leading, spacing: 8) {
                Text(AppSetting.shared.hasPassword ? L10n.Account.Infomation.changePassword : L10n.Account.Infomation.setPassword)
                    .font(Constant.ChangePassWord.fontTitle)
                Text(AppSetting.shared.hasPassword ? L10n.Account.Infomation.introChangePassword : L10n.Account.Infomation.setPasswordNote)
                    .font(Constant.ChangePassWord.fontSubContent)
                    .foregroundColor(Asset.Colors.lightBlackText.swiftUIColor)
            }
            Spacer()
        }
    }
    
    var passwordForms: some View {
        VStack(spacing: 16) {
            if AppSetting.shared.hasPassword {
                Form(placeholder: L10n.Account.Infomation.currentPassword,
                     value: $viewModel.password,
                     isPassword: true,
                     shouldAnimate: true,
                     width: Constant.Global.widthFormAndButton)
            }
            Form(placeholder: L10n.Account.Infomation.newPassword,
                 value: $viewModel.newPassword,
                 isPassword: true,
                 shouldAnimate: true,
                 width: Constant.Global.widthFormAndButton)
            Form(placeholder: L10n.Account.Infomation.retypePassword,
                 value: $viewModel.retypePassword,
                 isPassword: true,
                 shouldAnimate: true,
                 width: Constant.Global.widthFormAndButton)
        }
    }
    
    var submitButton: some View {
        AppButton(style: .themeButton,width: Constant.Global.widthFormAndButton, text: L10n.Account.Infomation.save) {
            viewModel.changePassword()
        }
    }
    
    var content: some View {
        VStack(spacing: 20) {
            LedgeTopView()
                .padding(.top, 10)
            header
            passwordForms
            submitButton
            Spacer().frame(height: 20)
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .background(AppColor.background)
        .cornerRadius(radius: Constant.Menu.radiusCell * 2, corners: [PositionItemCell.top.rectCorner])
        .padding(.top, -Constant.Menu.radiusCell * 2)
    }
    
    
    var body: some View {
        LoadingScreen(isShowing: $viewModel.showProgressView) {
            VStack {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        cancel?()
                    }
                content
                Spacer().frame(height: keyboardHeight)
            }
        }
        .background(PopupBackgroundView())
        .ignoresSafeArea()
        .onReceive(Publishers.keyboardHeight) { height in
            withAnimation(.spring(response: 0.4,
                                  dampingFraction: 1, blendDuration: 0)) {
                self.keyboardHeight = height
            }
        }
        .popup(isPresented: $viewModel.showAlert,
               type: .floater(verticalPadding: 20),
               position: .bottom,
               animation: .easeInOut,
               autohideIn: 5,
               closeOnTap: false,
               closeOnTapOutside: true) {
            PopupSelectView(message: viewModel.alertMessage,
                            confirmAction: {
                viewModel.showAlert = false
            })
            .onDisappear {
                if viewModel.changePasswordSuccess {
                    showChangePassword = false
                }
            }
        }
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    @State static var showChangePassword = true
    
    static var previews: some View {
        ChangePasswordView(viewModel: ChangePasswordViewModel(), showChangePassword: $showChangePassword)
    }
}
