//
//  SysVPN
//
//  Created by Da Phan Van on 14/01/2022.
//

import SwiftUI
import TunnelKitManager
import TunnelKitCore

struct AccountView: View {
    @EnvironmentObject var authentication: Authentication
    @Binding var showAccount: Bool
    @Binding var statusConnect: VPNStatus
    @State private var showInfomation = false
    @State private var showTotalDevice = false
    @State private var showAccountStatus = false
    @State private var showFAQ = false
    @State var numberOfSession: Int
    @StateObject var viewModel: AccountViewModel

    var header: some View {
        HStack(spacing: 25) {
            Image(Constant.Account.iconProfile)
                .padding(.leading, 20.0)
                .frame(height: Constant.Account.heightIconProfile)
            VStack(alignment: .leading, spacing: 8) {
                Text(verbatim: AppSetting.shared.email)
                    .font(Constant.Account.fontEmail)
                HStack {
                    if AppSetting.shared.emailVerified {
                        Asset.Assets.accountVerified.swiftUIImage
                        Text("Verified")
                            .font(.system(size: Constant.TextSize.AccountView.titleDefault, weight: .semibold))
                            .foregroundColor(.green)
                    } else {
                        Asset.Assets.accountNotVerified.swiftUIImage
                        Text("Unverified")
                            .font(.system(size: Constant.TextSize.AccountView.titleDefault, weight: .semibold))
                            .foregroundColor(Asset.Colors.pink.swiftUIColor)
                    }
                    Spacer().frame(width: 10)
                    Text("-")
                        .font(.system(size: Constant.TextSize.AccountView.titleDefault, weight: .regular))
                        .foregroundColor(Asset.Colors.lightBlackText.swiftUIColor)
                    Spacer().frame(width: 10)
                    Text(L10n.Account.viewProfile)
                        .font(.system(size: Constant.TextSize.AccountView.titleDefault, weight: .regular))
                        .foregroundColor(Asset.Colors.lightBlackText.swiftUIColor)
                }
            }
            .foregroundColor(Color.white)
            Spacer()
        }
        .onTapGesture {
            showInfomation.toggle()
        }
        .frame(height: Constant.Account.heightCellProfile)
        .background(AppColor.darkButton)
    }
    
    var content: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: true) {
                VStack(spacing: 0) {
                    if !AppSetting.shared.emailVerified {
                        verifyEmailSection
                    }
                    sectionsView
                    Spacer().frame(minHeight: 50)
                    AppButton(style: .darkButton, width: UIScreen.main.bounds.size.width - 30, text: L10n.Account.signout) {
                        viewModel.showLogoutConfirmation = true
                    }
                    Spacer()
                        .frame(height: 34)
                    navigationLinks
                }
                .frame(
                    minHeight: geometry.size.height,
                    maxHeight: .infinity,
                    alignment: .bottom
                )
            }
        }
        .background(AppColor.background)
        .ignoresSafeArea().frame(
            maxHeight: .infinity,
            alignment: .bottom
        )
    }

    var verifyEmailSection: some View {
        VStack {
            Spacer().frame(height: 20)
            VStack(alignment: .leading, spacing: 20) {
                    Text("Verify your email")
                    .font(.system(size: Constant.TextSize.AccountView.detailDefault,
                                  weight: .semibold))
                        .foregroundColor(Asset.Colors.pink.swiftUIColor)
                    Text("We’ve sent an email to your account to verify your email address and active account. The link in the email will expire in 24 hours.")
                        .font(.system(size: Constant.TextSize.AccountView.detailDefault))
                        .foregroundColor(Asset.Colors.lightBlackText.swiftUIColor)
                        .frame(height: 60, alignment: .leading)
                    Text("Resend email")
                        .font(.system(size: Constant.TextSize.AccountView.detailDefault))
                        .foregroundColor(.white)
                        .underline()
                        .onTapGesture {
                            viewModel.resendVerifyEmail()
                        }
                        .opacity(viewModel.shouldShowResendEmailButton ? 1 : 0)
                }
                .padding(20)
                .background(Asset.Colors.lightBlack.swiftUIColor)
                .cornerRadius(15)
                Spacer().frame(width: 20)
            Spacer().frame(height: 20)
        }
        .padding(.horizontal, 16)
    }
    
    var sectionsView: some View {
        HStack() {
            Spacer().frame(width: 25)
            VStack(alignment: .leading) {
                Spacer().frame(height: 10)
                Text(L10n.Account.account)
                    .font(Constant.Menu.fontSectionTitle)
                    .foregroundColor(AppColor.lightBlackText)
                Spacer().frame(height: 10)
                ItemRowView(item: ItemCell(type: .statusAccount)).onTapGesture {
                    self.showAccountStatus = true
                }
                Spacer().frame(height: 10)
                ItemRowView(item: ItemCell(type: .totalDevice)).onTapGesture {
                    self.showTotalDevice = true
                }
                Spacer().frame(height: 25)
                Text(L10n.Account.itemHelpCenter)
                    .font(Constant.Menu.fontSectionTitle)
                    .foregroundColor(AppColor.lightBlackText)
                Spacer().frame(height: 10)
                ItemRowView(item: ItemCell(type: .helpCenter)).onTapGesture {
                    self.showFAQ = true
                }
            }
            Spacer().frame(width: 25)
        }
    }
    
    var navigationLinks: some View {
        Group {
            NavigationLink(destination:
                            InfomationView(
                                showAccount: $showAccount,
                                showInfomation: $showInfomation,
                                statusConnect: $statusConnect,
                                viewModel: InfomationViewModel()),
                           isActive: $showInfomation) { }
            
            NavigationLink(destination:
                            AccountStatusView(
                                showAccount: $showAccount,
                                showAccountStatus: $showAccountStatus,
                                statusConnect: $statusConnect),
                           isActive: $showAccountStatus) { }
            
            NavigationLink(destination:
                            SessionVPNView(
                                showAccount: $showAccount,
                                showTotalDevice: $showTotalDevice,
                                statusConnect: $statusConnect,
                                viewModel: SessionVPNViewModel(),
                                shouldHideSessionList: .constant(false)),
                           isActive: $showTotalDevice) { }
            
            NavigationLink(destination:
                            FAQView(
                                showAccount: $showAccount,
                                showFAQ: $showFAQ,
                                statusConnect: $statusConnect,
                                viewModel: FAQViewModel()),
                           isActive: $showFAQ) { }
        }
    }
    
    var body: some View {
        LoadingScreen(isShowing: $viewModel.showProgressView) {
            VStack {
                AppColor.darkButton
                    .frame(height: 24)
                CustomNavigationView(
                    tapLeftButton: {
                        showAccount = false
                    }, tapRightButton: {
                        showAccount = false
                    }, statusConnect: $statusConnect)
                header
                content
            }
            .background(AppColor.background)
            .onAppear() {
                viewModel.authentication = authentication
                viewModel.shouldShowResendEmailButton = AppSetting.shared.shouldAllowSendVerifyEmail
                AppSetting.shared.fetchListSession()
            }
            .ignoresSafeArea()
            .onChange(of: AppSetting.shared.currentNumberDevice, perform: { numberOfDevices in
                self.numberOfSession = numberOfDevices
            })
            .popup(isPresented: $viewModel.showSuccessfullyResendEmail,
                   type: .floater(verticalPadding: 25, useSafeAreaInset: true),
                   position: .bottom,
                   animation: .easeInOut,
                   autohideIn: 5,
                   closeOnTap: false,
                   closeOnTapOutside: true, view: {
                PopupSelectView(message: "Successfully resend verify email.",
                                confirmAction: {
                    viewModel.showSuccessfullyResendEmail = false
                })
            })
            .popup(isPresented: $viewModel.showAlert,
                   type: .floater(verticalPadding: 25, useSafeAreaInset: true),
                   position: .bottom,
                   animation: .easeInOut,
                   autohideIn: 5,
                   closeOnTap: false,
                   closeOnTapOutside: true, view: {
                PopupSelectView(message: "An error occurred.",
                                confirmAction: {
                    viewModel.showAlert = false
                })
            })
            .sheet(isPresented: $viewModel.showLogoutConfirmation, content: {
                BottomViewPopup(cancel: {
                    viewModel.showLogoutConfirmation = false
                }, confim: {
                    viewModel.showLogoutConfirmation = false
                    viewModel.showProgressView = true
                    viewModel.logout()
                })
            })
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    @State static var showMenu = true
    @State static var value: VPNStatus = .connected
    
    static var previews: some View {
        AccountView(showAccount: $showMenu, statusConnect: $value, numberOfSession: AppSetting.shared.currentNumberDevice, viewModel: AccountViewModel())
    }
}
