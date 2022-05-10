//
//  AccountStatusView.swift
//  SysVPN
//
//  Created by Da Phan Van on 18/01/2022.
//

import SwiftUI

struct AccountStatusView: View {
    @Binding var showAccount: Bool
    
    @State var showPayment = false
    @State var statusConnect: BoardViewModel.StateBoard = .connected
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack(alignment: .top) {
                VStack {
                    AppColor.darkButton
                        .frame(height: 10)
                    CustomNavigationView(
                        leftTitle: L10n.Account.titleAccount,
                        currentTitle: L10n.Account.AccountStatus.title,
                        tapLeftButton: {
                            presentationMode.wrappedValue.dismiss()
                        }, tapRightButton: {
                            showAccount = false
                        }, statusConnect: statusConnect)
                    VStack(spacing: 1) {
                        ItemRowCell(title: ItemCellType.statusAccount.title,
                                    content: AppSetting.shared.isPremium ?
                                    "\(L10n.Account.expire) \(AppSetting.shared.premiumExpireDate?.toFormat("dd-MM-yyyy") ?? "")"
                                    : "\(L10n.Account.AccountStatus.joined): \(AppSetting.shared.joinedDate?.toFormat("dd-MM-yyyy") ?? "")",
                                    position: .top)
                        ItemRowCell(title: ItemCellType.paymentHistory.title,
                                    content: ItemCellType.paymentHistory.content,
                                    showRightButton: true,
                                    position: .bot)
                            .onTapGesture {
                                self.showPayment = true
                            }
                        Spacer().frame(height: 32)
                        AppButton(style: .themeButton, width: UIScreen.main.bounds.size.width - 32, text: AppSetting.shared.isPremium ? L10n.Account.AccountStatus.extend : L10n.Account.AccountStatus.upgradeToPremium) {
                            
                        }
                    }
                    .padding(Constant.Menu.hozitalPaddingCell)
                    .padding(.top, Constant.Menu.topPaddingCell)
                }
            }
            NavigationLink(destination: PaymentHistoryView(showAccount: $showAccount, statusConnect: statusConnect), isActive: $showPayment) { }
        }
        .navigationBarHidden(true)
        .background(AppColor.background)
        .ignoresSafeArea()
    }
}

struct AccountStatusView_Previews: PreviewProvider {
    @State static var show = true
    
    static var previews: some View {
        AccountStatusView(showAccount: $show)
    }
}
