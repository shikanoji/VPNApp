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
                  backgroundColor: AppColor.darkButton, textColor: AppColor.redradient,
                  textSize: 14, text: L10n.Account.deleteAccount) {
            deleteAccount = true }
                  .sheet(isPresented: $deleteAccount) {
                      DeleteAccountConfirmationView(viewModel: DeleteAccountConfirmationViewModel()) {
                          deleteAccount = false
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
                        showChangePassword = true
                    }
                }
            }
        }
        .padding(Constant.Menu.hozitalPaddingCell)
        .padding(.top, Constant.Menu.topPaddingCell)
        .sheet(isPresented: $showChangePassword) {
            ChangePasswordView(viewModel: ChangePasswordViewModel(), showChangePassword: $showChangePassword) {
                showChangePassword = false
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


