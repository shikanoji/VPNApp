//
//  SettingInfomationView.swift
//  SysVPN
//
//  Created by Da Phan Van on 17/01/2022.
//

import SwiftUI
import TunnelKitManager
import TunnelKitCore

struct InfomationView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var showAccount: Bool
    @Binding var showInfomation: Bool
    @Binding var statusConnect: VPNStatus
    @State var showChangePassword = false
    @State var deleteAccount = false

    @StateObject var viewModel: InfomationViewModel

    var deleteAccountButton: some View {
        AppButton(style: .none, width: UIScreen.main.bounds.size.width - 30, height: 44,
                  backgroundColor: AppColor.darkButton, textColor: AppColor.redradient, text: L10n.Account.deleteAccount) {
            deleteAccount = true
            if UIDevice.current.userInterfaceIdiom == .pad {
                viewModel.showDeleteAccountPad = true
            } else {
                viewModel.showDeleteAccountPhone = true
            }
        }
        .fullScreenCover(isPresented: $viewModel.showDeleteAccountPad) {
            DeleteAccountConfirmationView(viewModel: DeleteAccountConfirmationViewModel(requestDeleteSucces: {
                viewModel.showAlert = true
                viewModel.alertMessage = L10n.Global.requestDeleteMessage
            })) {
                viewModel.showDeleteAccountPad = false
            }
        }
        .sheet(isPresented: $viewModel.showDeleteAccountPhone) {
            DeleteAccountConfirmationView(viewModel: DeleteAccountConfirmationViewModel(requestDeleteSucces: {
                viewModel.showAlert = true
                viewModel.alertMessage = L10n.Global.requestDeleteMessage
            })) {
                viewModel.showDeleteAccountPhone = false
            }
        }
    }

    var itemList: some View {
        VStack(spacing: 1) {
            ForEach(viewModel.section.items, id: \.id) { item in
                ItemRowCell(title: item.type.title,
                            content: item.type.content,
                            position: viewModel.section.items.getPosition(item))
                    .environmentObject(viewModel)
                    .onTapGesture {
                        if item.type == .accountSecurity {
                            if UIDevice.current.userInterfaceIdiom == .pad {
                                viewModel.showChangePasswordPad = true
                            } else {
                                viewModel.showChangePasswordPhone = true
                            }
                        }
                    }
            }
        }
        .padding(Constant.Menu.hozitalPaddingCell)
        .padding(.top, Constant.Menu.topPaddingCell)
        .fullScreenCover(isPresented: $viewModel.showChangePasswordPad) {
            ChangePasswordView(viewModel: ChangePasswordViewModel(), showChangePassword: $showChangePassword) {
                showChangePassword = false
                viewModel.showChangePasswordPad = false
            }
            .clearModalBackground()
        }
        .sheet(isPresented: $viewModel.showChangePasswordPhone) {
            ChangePasswordView(viewModel: ChangePasswordViewModel(), showChangePassword: $showChangePassword) {
                showChangePassword = false
                viewModel.showChangePasswordPhone = false
            }
            .clearModalBackground()
        }
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack(alignment: .top) {
                VStack {
                    AppColor.darkButton
                        .frame(height: 10)
                    CustomNavigationView(
                        leftTitle: L10n.Account.titleAccount,
                        currentTitle: L10n.Account.titleAccount,
                        tapLeftButton: {
                            presentationMode.wrappedValue.dismiss()
                        }, tapRightButton: {
                            UINavigationBar.setAnimationsEnabled(false)
                            showAccount = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                UINavigationBar.setAnimationsEnabled(true)
                            }
                        }, statusConnect: $statusConnect)
                    itemList
                    Spacer()
                    deleteAccountButton
                }
            }
        }
        .popup(isPresented: $viewModel.showAlert, type: .floater(verticalPadding: 10), position: .bottom, animation: .easeInOut, autohideIn: 5, closeOnTap: false, closeOnTapOutside: true) {
            PopupSelectView(message: viewModel.alertMessage,
                            confirmAction: {
                                viewModel.showAlert = false
                            })
        }
        .navigationBarHidden(true)
        .background(AppColor.background)
        .ignoresSafeArea()
    }
}

struct SettingInfomationView_Previews: PreviewProvider {

    @State static var showChangePassword = false
    @State static var showAccount = true
    @State static var value: VPNStatus = .connected

    static var previews: some View {
        InfomationView(showAccount: $showAccount, showInfomation: $showAccount, statusConnect: .constant(.connected), viewModel: InfomationViewModel())
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


