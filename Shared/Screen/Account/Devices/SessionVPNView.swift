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
    
    @State var refresh = Refresh(started: false, released: false)
    @State var firstLoad = true
    @State var hiddenRefresh = false
    
    var body: some View {
        VStack(spacing: 1) {
            AppColor.darkButton
                .frame(height: 20)
            CustomNavigationViewUpdate(
                leftTitle: L10n.Account.titleAccount,
                currentTitle: $viewModel.currentNumberDevice,
                tapLeftButton: {
                    presentationMode.wrappedValue.dismiss()
                    shouldHideSessionList = true
                    UIScrollView.appearance().bounces = false
                }, tapRightButton: {                    UIScrollView.appearance().bounces = false
                    UINavigationBar.setAnimationsEnabled(false)
                    showAccount = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        UINavigationBar.setAnimationsEnabled(true)
                    }
                }, statusConnect: $statusConnect)
                .padding(.bottom, Constant.Menu.topPaddingCell)
            Spacer().frame(height: 15)
            LoadingScreen(isShowing: $viewModel.showProgressView) {
                ScrollView(.vertical, showsIndicators: false) {
                    GeometryReader { reader -> AnyView in
                        
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
                            
                            // Checking if refresh í started and drag is released
                            if refresh.startOffset == refresh.offset && refresh.started && !refresh.released {
                                withAnimation(Animation.linear) {refresh.released = true}
                                refreshData()
                            }
                            
                            // checking if invalid becomes valid
                            if refresh.startOffset == refresh.offset && refresh.started && refresh.released && refresh.invalid {
                                refresh.invalid = false
                                refreshData()
                            }
                        }
                        return AnyView(Color.black.frame(width: 0, height: 0))
                    }
                    .frame(width: 0, height: 0)
                    
                    if refresh.started && !firstLoad && !hiddenRefresh {
                        Image(systemName: "arrow.clockwise.circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(.bottom)
                    }
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
                }, confirm: {
                    viewModel.showPopupView = false
                    viewModel.disconnectSession()
                })
        })
        .onAppear {
            viewModel.getListSession()
            UIScrollView.appearance().bounces = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                firstLoad = false
            }
        }
        .ignoresSafeArea()
    }
    
    func refreshData() {
        
        withAnimation(Animation.linear) {
            if refresh.startOffset == refresh.offset {
                viewModel.getListSession()
                refresh.released = false
                refresh.started = false
            }
            else {
                refresh.invalid = true
            }
        }
    }
}

struct DevicesView_Previews: PreviewProvider {
    @State static var showAccount = true
    
    static var previews: some View {
        SessionVPNView(showAccount: $showAccount, showTotalDevice: $showAccount, statusConnect: .constant(.connected), viewModel: SessionVPNViewModel(), shouldHideSessionList: .constant(false))
    }
}

