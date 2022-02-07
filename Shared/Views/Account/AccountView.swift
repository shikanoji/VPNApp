//
//  SysVPN
//
//  Created by Da Phan Van on 14/01/2022.
//

import SwiftUI

struct AccountView: View {
    @Binding var showAccount: Bool
    
    @Binding var statusConnect: BoardViewModel.StateBoard
    
    @State private var showInfomation = false
    
    @State private var showTotalDevice = false
    
    @State private var showAccountStatus = false
    
    @State var sections: [DataSection] = [
        DataSection(type: .myAccount),
        DataSection(type: .helpSupport)
    ]
    
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
            HStack(spacing: 25) {
                Image(Constant.Account.iconProfile)
                    .padding(.leading, 20.0)
                    .frame(height: Constant.Account.heightIconProfile)
                VStack(alignment: .leading, spacing: 8) {
                    Text(verbatim: "flashkick2001@gmail.com")
                        .font(Constant.Account.fontEmail)
                    //                    Text(AppSetting.shared.email)
                    Text(LocalizedStringKey.Account.tapControlProfile.localized)
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
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(sections, id: \.id) { section in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(section.type.title)
                                    .font(Constant.Menu.fontSectionTitle)
                                    .foregroundColor(AppColor.lightBlackText)
                                ForEach(section.type.items) { item in
                                    ItemRowView(item: item)
                                        .onTapGesture {
                                            switch item.type {
                                            case .statusAccount:
                                                self.showAccountStatus = true
                                            case .totalDevice:
                                                self.showTotalDevice = true
                                            default:
                                                return
                                            }
                                        }
                                }
                            }
                        }
                        .padding([.top, .leading])
                        Spacer()
                        AppButton(style: .darkButton, width: UIScreen.main.bounds.size.width - 30, text: LocalizedStringKey.Account.signOut.localized) {
                            print("Log out")
                        }
                        Spacer()
                            .frame(height: 34)
                        NavigationLink(destination: InfomationView(showAccount: $showAccount, statusConnect: statusConnect), isActive: $showInfomation) { }
                        NavigationLink(destination: AccountStatusView(showAccount: $showAccount, statusConnect: statusConnect), isActive: $showAccountStatus) { }
                        NavigationLink(destination: DevicesView(showAccount: $showAccount, statusConnect: statusConnect), isActive: $showTotalDevice) { }
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
        .background(AppColor.background)
    }
}

struct AccountView_Previews: PreviewProvider {
    @State static var showMenu = true
    @State static var value: BoardViewModel.StateBoard = .connected
    
    static var previews: some View {
        AccountView(showAccount: $showMenu, statusConnect: $value)
    }
}
