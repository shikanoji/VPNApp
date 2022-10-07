//
//  PaymentHistoryView.swift
//  SysVPN
//
//  Created by Da Phan Van on 18/01/2022.
//

import SwiftUI
import TunnelKitManager
import SwiftDate

struct Refresh {
    var startOffset: CGFloat = 0
    var offset: CGFloat = 0
    var started: Bool
    var released: Bool
    var invalid: Bool = false
}

struct PaymentHistoryView: View {
    
    @Binding var showAccount: Bool
    @Binding var showAccountStatus: Bool
    @Binding var statusConnect: VPNStatus
    @StateObject var viewModel: PaymentHistoryViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var refresh = Refresh(started: false, released: false)
    
    @State var firstLoad = true
    @State var hiddenRefresh = false
    
    var body: some View {
        VStack {
            AppColor.darkButton
                .frame(height: 10)
            CustomNavigationView(
                leftTitle: L10n.Account.AccountStatus.title,
                currentTitle: L10n.Account.AccountStatus.paymentHistory,
                tapLeftButton: {
                    UIScrollView.appearance().bounces = false
                    presentationMode.wrappedValue.dismiss()
                }, tapRightButton: {
                    UIScrollView.appearance().bounces = false
                    UINavigationBar.setAnimationsEnabled(false)
                    showAccount = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        UINavigationBar.setAnimationsEnabled(true)
                    }
                }, statusConnect: $statusConnect)
            .padding(.bottom, Constant.Menu.topPaddingCell)
            LoadingScreen(isShowing: $viewModel.showProgressView) {
                ScrollView(.vertical, showsIndicators: false) {
                    
                    GeometryReader{ reader -> AnyView in
                        
                        DispatchQueue.main.async {
                            if refresh.startOffset == 0 {
                                refresh.startOffset = reader.frame(in: .global).minY
                            }
                            
                            refresh.offset = reader.frame(in: .global).minY
                            
                            if refresh.offset - refresh.startOffset > 40 && !refresh.started {
                                refresh.started = true
                                hiddenRefresh = false
                            }
                            
                            if refresh.offset <= refresh.startOffset + 20 {
                                withAnimation(Animation.linear) {
                                    hiddenRefresh = true
                                }
                            }
                            
                            //Checking if refresh í started and drag is released
                            if refresh.startOffset == refresh.offset && refresh.started && !refresh.released {
                                withAnimation(Animation.linear){refresh.released = true}
                                refreshData()
                            }
                            
                            //checking if invalid becomes valid
                            if refresh.startOffset == refresh.offset && refresh.started && refresh.released && refresh.invalid{
                                refresh.invalid = false
                                refreshData()
                            }
                        }
                        return AnyView(Color.black.frame(width: 0, height: 0))
                    }
                    .frame(width: 0, height: 0)
                    
                    VStack(spacing: 1) {
                        if refresh.started && !firstLoad && !hiddenRefresh {
                            Image(systemName: "arrow.clockwise.circle")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.bottom)
                                .padding(.top, -20)
                        }
                            ForEach(viewModel.paymentHistory.indices, id: \.self) { index in
                                let item = viewModel.paymentHistory[index]
                                ItemRowCell(title: item.packageCharge.productName,
                                            content: (item.status == "complete" ?
                                                      L10n.Account.AccountStatus.PaymentHistory.success : L10n.Account.AccountStatus.PaymentHistory.failed) + " - " + item.paymentDate,
                                            position: viewModel.paymentHistory.getPosition(index))
                                .onAppear {
                                    if index == viewModel.paymentHistory.count - 1, viewModel.enableLoadMore, !viewModel.showProgressView {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        viewModel.fetchPaymentHistory(true)
                                    }
                                }
                            }
                        }
                    }
                    .padding(Constant.Menu.hozitalPaddingCell)
                }
            }
            .navigationBarHidden(true)
            .background(AppColor.background)
        }
        .onAppear {
            viewModel.fetchPaymentHistory()
            UIScrollView.appearance().bounces = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                firstLoad = false
            }
        }
        .onDisappear {
            UIScrollView.appearance().bounces = false
        }
        .background(AppColor.background)
        .ignoresSafeArea()
    }
    
    func refreshData(){
        
        withAnimation(Animation.linear) {
            if refresh.startOffset == refresh.offset {
                viewModel.fetchPaymentHistory()
                refresh.released = false
                refresh.started = false
            }
            else {
                refresh.invalid = true
            }
        }
    }
}

struct PaymentHistoryView_Previews: PreviewProvider {
    @State static var showAccount = true
    
    static var previews: some View {
        PaymentHistoryView(showAccount: $showAccount, showAccountStatus: $showAccount, statusConnect: .constant(.connected), viewModel: PaymentHistoryViewModel())
    }
}
