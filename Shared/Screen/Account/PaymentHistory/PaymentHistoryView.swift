//
//  PaymentHistoryView.swift
//  SysVPN
//
//  Created by Da Phan Van on 18/01/2022.
//

import SwiftUI
import TunnelKitManager
import SwiftDate

struct PaymentHistoryView: View {
    
    @Binding var showAccount: Bool
    @Binding var showAccountStatus: Bool
    @Binding var statusConnect: VPNStatus
    @StateObject var viewModel: PaymentHistoryViewModel
    
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
                        }, statusConnect: $statusConnect)
                    VStack(spacing: 1) {
                        ForEach(viewModel.paymentHistory.indices, id: \.self) { index in
                            let item = viewModel.paymentHistory[index]
                            ItemRowCell(title: item.packageName,
                                        content: item.status + " - " + item.paymentDate,
                                        alertContent: "",
                                        position: viewModel.paymentHistory.getPosition(index))
                        }
                    }
                    .padding(Constant.Menu.hozitalPaddingCell)
                    .padding(.top, Constant.Menu.topPaddingCell)
                }
                .onAppear {
                    viewModel.fetchPaymentHistory()
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
        PaymentHistoryView(showAccount: $showAccount, showAccountStatus: $showAccount, statusConnect: .constant(.connected), viewModel: PaymentHistoryViewModel())
    }
}
