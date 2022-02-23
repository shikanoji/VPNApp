//
//  SettingInfomationView.swift
//  SysVPN
//
//  Created by Da Phan Van on 17/01/2022.
//

import SwiftUI

struct InfomationView: View {
    
    @Binding var showAccount: Bool
    @State var statusConnect: BoardViewModel.StateBoard = .connected
    @State var showChangePassword = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack(alignment: .top) {
                VStack {
                    AppColor.darkButton
                        .frame(height: 10)
                    CustomNavigationView(
                        leftTitle: LocalizedStringKey.Account.titleAccount.localized,
                        currentTitle: LocalizedStringKey.Account.titleAccount.localized,
                        tapLeftButton: {
                            presentationMode.wrappedValue.dismiss()
                        }, tapRightButton: {
                            showAccount = false
                        }, statusConnect: statusConnect)
                    VStack(spacing: 1) {
                        ItemRowCell(title: LocalizedStringKey.Infomation.emailCell.localized,
                                    content: AppSetting.shared.email,
                                    position: .top)
                        ItemRowCell(title: LocalizedStringKey.Infomation.memberCell.localized,
                                    content: AppSetting.shared.getDateMemberSince())
                        ItemRowCell(title: LocalizedStringKey.Infomation.idCell.localized,
                                    content: AppSetting.shared.idVPN)
                        ItemRowCell(title: LocalizedStringKey.Infomation.securityCell.localized,
                                    content: LocalizedStringKey.Infomation.tapToChange.localized,
                                    position: .bot)
                            .onTapGesture {
                                showChangePassword = true
                            }
                    }
                    .padding(Constant.Menu.hozitalPaddingCell)
                    .padding(.top, Constant.Menu.topPaddingCell)
                    .fullScreenCover(isPresented: $showChangePassword) {

                    } content: {
                        ChangePasswordView(viewModel: ChangePasswordViewModel(), showChangePassword: $showChangePassword)
                            .clearModalBackground()
                    }

                }
            }
        }
        .navigationBarHidden(true)
        .background(AppColor.background)
        .ignoresSafeArea()
    }
}

struct SettingInfomationView_Previews: PreviewProvider {
    
    @State static var showChangePassword = false
    @State static var showAccount = true
    @State static var value: BoardViewModel.StateBoard = .connected
    
    static var previews: some View {
        InfomationView(showAccount: $showAccount)
    }
}

struct ClearBackgroundView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

struct ClearBackgroundViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background(ClearBackgroundView())
    }
}

extension View {
    func clearModalBackground()->some View {
        self.modifier(ClearBackgroundViewModifier())
    }
}
