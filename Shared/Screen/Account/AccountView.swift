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
                Text(L10n.Account.tapControl)
                    .font(Constant.Account.fontSubEmail)
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
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    sectionsView
                    Spacer()
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
        ZStack {
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
                AppSetting.shared.fetchListSession()
            }
            if viewModel.showProgressView {
                LoadingView()
            }
        }
        .onChange(of: AppSetting.shared.currentNumberDevice, perform: { numberOfDevices in
            self.numberOfSession = numberOfDevices
        })
        .popup(isPresented: $viewModel.showLogoutConfirmation,
               type: .floater(verticalPadding: 10),
               position: .bottom,
               animation: .easeInOut,
               autohideIn: nil,
               closeOnTap: true,
               closeOnTapOutside: true) {
            BottomViewPopup(cancel: {
                viewModel.showLogoutConfirmation = false
            }, confim: {
                viewModel.showLogoutConfirmation = false
                viewModel.showProgressView = true
                viewModel.logout()
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
