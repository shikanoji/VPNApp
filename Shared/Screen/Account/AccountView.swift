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
    
    @StateObject var viewModel: AccountViewModel
    
    @State var sections: [DataSection] = [
        DataSection(type: .myAccount),
        DataSection(type: .helpSupport)
    ]
    
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
                        viewModel.logout()
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
        .animation(nil)
        .background(AppColor.background)
        .ignoresSafeArea().frame(
            maxHeight: .infinity,
            alignment: .bottom
        )
    }
    
    var sectionsView: some View {
        ForEach(sections, id: \.id) { section in
            VStack(alignment: .leading, spacing: 10) {
                Text(section.type.title)
                    .font(Constant.Menu.fontSectionTitle)
                    .foregroundColor(AppColor.lightBlackText)
                ForEach(section.type.items) { item in
                    Button {
                        switch item.type {
                        case .statusAccount:
                            self.showAccountStatus = true
                        case .totalDevice:
                            self.showTotalDevice = true
                        default:
                            return
                        }
                    } label: {
                        ItemRowView(item: item)
                    }
                }
            }
        }
        .padding([.top, .leading])
    }
    
    var navigationLinks: some View {
        Group {
            NavigationLink(destination:
                            InfomationView(
                                showAccount: $showAccount,
                                showInfomation: $showInfomation,
                                statusConnect: statusConnect),
                           isActive: $showInfomation) { }
            
            NavigationLink(destination:
                            AccountStatusView(
                                showAccount: $showAccount,
                                showAccountStatus: $showAccountStatus,
                                statusConnect: statusConnect),
                           isActive: $showAccountStatus) { }
            
            NavigationLink(destination:
                            DevicesView(
                                showAccount: $showAccount,
                                showTotalDevice: $showTotalDevice,
                                statusConnect: statusConnect,
                                viewModel: DeviceViewModel()),
                           isActive: $showTotalDevice) { }
            
            NavigationLink(destination:
                            FAQView(
                                showAccount: $showAccount,
                                statusConnect: statusConnect,
                                viewModel: FAQViewModel()),
                           isActive: $showFAQ) { }
        }
    }
    
    var body: some View {
        VStack {
            AppColor.darkButton
                .frame(height: 24)
            CustomNavigationView(
                tapLeftButton: {
                    showAccount = false
                }, tapRightButton: {
                    showAccount = false
                }, statusConnect: statusConnect)
            header
            content
        }
        .background(AppColor.background)
        .onAppear() {
            viewModel.authentication = authentication
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    @State static var showMenu = true
    @State static var value: VPNStatus = .connected
    
    static var previews: some View {
        AccountView(showAccount: $showMenu, statusConnect: $value, viewModel: AccountViewModel())
    }
}
