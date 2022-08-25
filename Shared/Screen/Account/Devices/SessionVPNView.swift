//
//  DevicesView.swift
//  SysVPN
//
//  Created by Da Phan Van on 18/01/2022.
//

import SwiftUI
import TunnelKitManager

struct SessionVPNView: View {
    @Binding var showAccount: Bool
    @Binding var showTotalDevice: Bool
    
    @Binding var statusConnect: VPNStatus
    @ObservedObject var viewModel: SessionVPNViewModel
    @Binding var shouldHideSessionList: Bool
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack(alignment: .top) {
                VStack(spacing: 1) {
                    AppColor.darkButton
                        .frame(height: 20)
                    CustomNavigationViewUpdate(
                        leftTitle: L10n.Account.AccountStatus.title,
                        currentTitle: $viewModel.currentNumberDevice.string(),
                        tapLeftButton: {
                            presentationMode.wrappedValue.dismiss()
                            shouldHideSessionList = true
                        }, tapRightButton: {
                            showTotalDevice = false
                            showAccount = false
                            shouldHideSessionList = true
                        }, statusConnect: $statusConnect)
                    .padding(.bottom, Constant.Menu.topPaddingCell)
                    Spacer().frame(height: 15)
                    ForEach(viewModel.deviceList.indices, id: \.self) { i in
                        SessionVPNCell(sessionVPN: viewModel.deviceList[i],
                                       position: viewModel.deviceList.getPosition(i)) {
                            viewModel.disconnectSession(viewModel.deviceList[i])
                        }
                    }
                    .padding(.horizontal, Constant.Menu.hozitalPaddingCell)
                }
                if viewModel.showProgressView {
                    LoadingView()
                        .padding(.top, UIScreen.main.bounds.size.height / 2)
                }
            }
        }
        .navigationBarHidden(true)
        .background(AppColor.background)
        .ignoresSafeArea()
        .popup(isPresented: $viewModel.showAlert, type: .floater(verticalPadding: 10), position: .bottom, animation: .easeInOut, autohideIn: 10, closeOnTap: false, closeOnTapOutside: true) {
            ToastView(title: viewModel.error?.title ?? "",
                      message: viewModel.error?.description ?? "",
                      cancelAction: {
                viewModel.showAlert = false
            })
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                viewModel.getListSession()
            })
        }
    }
}

struct DevicesView_Previews: PreviewProvider {
    @State static var showAccount = true
    
    static var previews: some View {
        SessionVPNView(showAccount: $showAccount, showTotalDevice: $showAccount, statusConnect: .constant(.connected), viewModel: SessionVPNViewModel(), shouldHideSessionList: .constant(false))
    }
}
