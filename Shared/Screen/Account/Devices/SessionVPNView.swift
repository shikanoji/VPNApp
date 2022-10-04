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
    @StateObject var viewModel: SessionVPNViewModel
    @Binding var shouldHideSessionList: Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        LoadingScreen(isShowing: $viewModel.showProgressView) {
            ScrollView(.vertical, showsIndicators: false) {
                ZStack(alignment: .top) {
                    VStack(spacing: 1) {
                        AppColor.darkButton
                            .frame(height: 20)
                        CustomNavigationViewUpdate(
                            leftTitle: L10n.Account.titleAccount,
                            currentTitle: $viewModel.currentNumberDevice,
                            tapLeftButton: {
                                presentationMode.wrappedValue.dismiss()
                                shouldHideSessionList = true
                            }, tapRightButton: {
                                UINavigationBar.setAnimationsEnabled(false)
                                showAccount = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    UINavigationBar.setAnimationsEnabled(true)
                                }
                            }, statusConnect: $statusConnect)
                        .padding(.bottom, Constant.Menu.topPaddingCell)
                        Spacer().frame(height: 15)
                        ForEach($viewModel.deviceList.indices, id: \.self) { i in
                            SessionVPNCell(sessionVPN: viewModel.deviceList[i],
                                           position: viewModel.deviceList.getPosition(i)) {
                                viewModel.sessionSelect = viewModel.deviceList[i]
                                viewModel.showPopupView = true
                            }
                        }
                        .padding(.horizontal, Constant.Menu.hozitalPaddingCell)
                    }
                }
            }
            .navigationBarHidden(true)
            .background(AppColor.background)
            .popup(isPresented: $viewModel.showAlert,
                   type: .floater(verticalPadding: 20,
                                  useSafeAreaInset: true),
                   position: .bottom,
                   animation: .easeInOut,
                   autohideIn: 5,
                   closeOnTap: false,
                   closeOnTapOutside: true,
                   view: {
                PopupSelectView(message: viewModel.error?.description ?? "An error occurred",
                                confirmAction: {
                    viewModel.showAlert = false
                })
            })
            .popup(isPresented: $viewModel.showSessionTerminatedAlert,
                   type: .floater(verticalPadding: 20,
                                  useSafeAreaInset: true),
                   position: .bottom,
                   animation: .easeInOut,
                   autohideIn: 5,
                   closeOnTap: false,
                   closeOnTapOutside: true,
                   view: {
                PopupSelectView(message: "Successfully terminate session!",
                                confirmAction: {
                    viewModel.showSessionTerminatedAlert = false
                })
            })
            .sheet(isPresented: $viewModel.showPopupView, content: {
                BottomViewPopup(
                    titleStr: L10n.Account.Session.Terminal.title,
                    messageStr: L10n.Account.Session.Terminal.message,
                    confirmStr: L10n.Account.Session.Terminal.terminate,
                    warning: true,
                    cancel: {
                        viewModel.showPopupView = false
                    }, confim: {
                        viewModel.showPopupView = false
                        viewModel.disconnectSession()
                    })
            })
            .onAppear {
                viewModel.getListSession()
            }
        }
        .ignoresSafeArea()
    }
}

struct DevicesView_Previews: PreviewProvider {
    @State static var showAccount = true
    
    static var previews: some View {
        SessionVPNView(showAccount: $showAccount, showTotalDevice: $showAccount, statusConnect: .constant(.connected), viewModel: SessionVPNViewModel(), shouldHideSessionList: .constant(false))
    }
}

