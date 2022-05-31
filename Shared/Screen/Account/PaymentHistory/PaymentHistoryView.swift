//
//  PaymentHistoryView.swift
//  SysVPN
//
//  Created by Da Phan Van on 18/01/2022.
//

import SwiftUI
import TunnelKitManager

struct PaymentHistoryView: View {
    
    @Binding var showAccount: Bool
    @Binding var showAccountStatus: Bool
    @State var statusConnect: VPNStatus = .connected
    
    @State var paymentHistoryList = [PaymentHistory(cancel: true), PaymentHistory(), PaymentHistory()]
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack(alignment: .top) {
                VStack {
                    AppColor.darkButton
                        .frame(height: 10)
                    CustomNavigationView(
                        leftTitle: L10n.Account.AccountStatus.title,
                        currentTitle: L10n.Account.AccountStatus.paymentHistory,
                        tapLeftButton: {
                            presentationMode.wrappedValue.dismiss()
                        }, tapRightButton: {
                            showAccountStatus = false
                            showAccount = false
                        }, statusConnect: statusConnect)
                    VStack(spacing: 1) {
                        ForEach(paymentHistoryList.indices) { i in
                            ItemRowCell(title: paymentHistoryList[i].pack,
                                        content: paymentHistoryList[i].contentStatus + " - " + paymentHistoryList[i].date,
                                        alertContent: i == 0 ? L10n.Account.PaymentHistory.cancelSubscription : "",
                                        position: paymentHistoryList.getPosition(i))
                        }
                    }
                    .padding(Constant.Menu.hozitalPaddingCell)
                    .padding(.top, Constant.Menu.topPaddingCell)
                }
            }
        }
        .navigationBarHidden(true)
        .background(AppColor.background)
        .ignoresSafeArea()
    }
}

struct PaymentHistoryView_Previews: PreviewProvider {
    @State static var showAccount = true
    
    static var previews: some View {
        PaymentHistoryView(showAccount: $showAccount, showAccountStatus: $showAccount)
    }
}
