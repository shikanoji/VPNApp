//
//  ChangePasswordView.swift
//  SysVPN
//
//  Created by Da Phan Van on 17/01/2022.
//

import SwiftUI

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

struct ChangePasswordView: View {
    @StateObject var viewModel: ChangePasswordViewModel
    @Binding var showChangePassword: Bool
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    VisualEffectView(effect: UIBlurEffect(style: .dark))
                        .opacity(0.95)
                    HStack {
                        Image(Constant.CustomNavigation.iconBack)
                            .onTapGesture {
                                self.showChangePassword = false
                            }
                        Spacer()
                    }
                    .padding(.top, 35.0)
                }
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(LocalizedStringKey.Infomation.changePassword.localized)
                            .font(Constant.ChangePassWord.fontTitle)
                        Text(LocalizedStringKey.Infomation.introChangePassword.localized)
                            .font(Constant.ChangePassWord.fontSubContent)
                    }
                    .padding(.vertical)
                    Group{
                        Form(placeholder: LocalizedStringKey.Infomation.currentPassword.localized, value: $viewModel.password,
                             isPassword: true)
                        Spacer().frame(height: 16)
                        Form(placeholder: LocalizedStringKey.Infomation.newPassword.localized, value: $viewModel.newPassword, isPassword: true)
                        Spacer().frame(height: 16)
                        Form(placeholder: LocalizedStringKey.Infomation.retypePassword.localized, value: $viewModel.newPassword, isPassword: true)
                        Spacer().frame(height: 16)
                        if viewModel.showProgressView {
                            ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        }
                        Spacer().frame(height: 20)
                        AppButton(style: .themeButton, width: 311, text: LocalizedStringKey.Infomation.save.localized) {
                            self.showChangePassword = false
                        }
                        Spacer().frame(height: 40)
                    }
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .background(AppColor.darkButton)
                .cornerRadius(radius: Constant.Menu.radiusCell * 2, corners: [PositionItemCell.top.rectCorner])
                .padding(.top, -Constant.Menu.radiusCell * 2)
            }
            if viewModel.showProgressView {
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    @State static var showChangePassword = true
    
    static var previews: some View {
        ChangePasswordView(viewModel: ChangePasswordViewModel(), showChangePassword: $showChangePassword)
    }
}
