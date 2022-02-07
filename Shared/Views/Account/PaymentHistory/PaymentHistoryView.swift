//
//  PaymentHistoryView.swift
//  SysVPN
//
//  Created by Da Phan Van on 18/01/2022.
//

import SwiftUI

struct PaymentHistoryView: View {
    
    @Binding var showAccount: Bool
    @State var statusConnect: BoardViewModel.StateBoard = .connected
    
    @State var paymentHistoryList = [PaymentHistory(cancel: true), PaymentHistory(), PaymentHistory()]
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack(alignment: .top) {
                VStack {
                    AppColor.darkButton
                        .frame(height: 10)
                    CustomNavigationView(
                        leftTitle: LocalizedStringKey.AccountStatus.title.localized,
                        currentTitle: LocalizedStringKey.AccountStatus.paymentHistory.localized,
                        tapLeftButton: {
                            presentationMode.wrappedValue.dismiss()
                        }, tapRightButton: {
                            showAccount = false
                        }, statusConnect: statusConnect)
                    VStack(spacing: 1) {
                        ForEach(paymentHistoryList.indices) { i in
                            ItemRowCell(title: paymentHistoryList[i].pack,
                                        content: paymentHistoryList[i].contentStatus + " - " + paymentHistoryList[i].date,
                                        alertContent: i == 0 ? LocalizedStringKey.Account.cancelSubscribe.localized : "",
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
        PaymentHistoryView(showAccount: $showAccount)
    }
}
