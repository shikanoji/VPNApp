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
                            .font(.system(size: Constant.TextSize.Global.description, weight: .semibold))
                            .foregroundColor(.green)
                    } else {
                        Asset.Assets.accountNotVerified.swiftUIImage
                        Text("Unverified")
                            .font(.system(size: Constant.TextSize.Global.description, weight: .semibold))
                            .foregroundColor(Asset.Colors.pink.swiftUIColor)
                    }
                    Spacer().frame(width: 10)
                    Text("-")
                        .font(.system(size: Constant.TextSize.Global.description, weight: .regular))
                        .foregroundColor(Asset.Colors.lightBlackText.swiftUIColor)
                    Spacer().frame(width: 10)
                    Text(L10n.Account.viewProfile)
                        .font(.system(size: Constant.TextSize.Global.description, weight: .regular))
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
                            .padding(.top, 24)
                            .padding(.horizontal, 16)
                    }
                    sectionsView
                        .padding(.top, 32)
                        .padding(.horizontal, 16)
                    Spacer().frame(minHeight: 50)
                    AppButton(style: .darkButton, width: UIScreen.main.bounds.size.width - 30, text: L10n.Account.signout) {
                        if UIDevice.current.userInterfaceIdiom == .pad {
                            viewModel.showLogoutConfirmationPad = true
                        } else {
                            viewModel.showLogoutConfirmationPhone = true
                        }
                    }
                    Spacer()
                        .frame(height: 27)
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
        VStack(alignment: .leading, spacing: 20) {
            Text("Verify your email")
                .font(.system(size: Constant.TextSize.Global.detailDefault,
                              weight: .semibold))
                .foregroundColor(Asset.Colors.pink.swiftUIColor)
            Text("We’ve sent an email to your account to verify your email address and active account. The link in the email will expire in 24 hours.")
                .font(.system(size: Constant.TextSize.Global.detailDefault))
                .foregroundColor(Asset.Colors.lightBlackText.swiftUIColor)
                .frame(maxWidth: .infinity, maxHeight: 70, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
            if (viewModel.shouldShowResendEmailButton == false) { }
            else {
                Text("Resend email")
                    .font(.system(size: Constant.TextSize.Global.detailDefault))
                    .foregroundColor(.white)
                    .underline()
                    .onTapGesture {
                        viewModel.resendVerifyEmail()
                    }
            }
        }
        .padding(24)
        .background(Asset.Colors.lightBlack.swiftUIColor)
        .cornerRadius(15)
    }
    
    var sectionsView: some View {
        HStack() {
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
                ItemRowView(item: ItemCell(type: .totalDevice), title: L10n.Account.itemDevices + ": \(numberOfSession)/\(AppSetting.shared.maxNumberDevices)").onTapGesture {
                    self.showTotalDevice = true
                }
                Spacer().frame(height: 35)
                Text(L10n.Account.itemHelpCenter)
                    .font(Constant.Menu.fontSectionTitle)
                    .foregroundColor(AppColor.lightBlackText)
                Spacer().frame(height: 10)
                ItemRowView(item: ItemCell(type: .helpCenter)).onTapGesture {
                    self.showFAQ = true
                }
            }
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
                    viewModel: SessionVPNViewModel()),
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
            .onWillAppear {
                viewModel.authentication = authentication
                DispatchQueue.main.async {
                    viewModel.shouldShowResendEmailButton = AppSetting.shared.shouldAllowSendVerifyEmail
                }
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
            .fullScreenCover(isPresented: $viewModel.showLogoutConfirmationPad, content: {
                BottomViewPopup(cancel: {
                    viewModel.showLogoutConfirmationPad = false
                }, confirm: {
                    viewModel.showLogoutConfirmationPad = false
                    viewModel.showProgressView = true
                    Task {
                        await viewModel.logout()
                    }
                })
            })
            .sheet(isPresented: $viewModel.showLogoutConfirmationPhone, content: {
                BottomViewPopup(cancel: {
                    viewModel.showLogoutConfirmationPhone = false
                }, confirm: {
                    viewModel.showLogoutConfirmationPhone = false
                    viewModel.showProgressView = true
                    Task {
                        await viewModel.logout()
                    }
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
