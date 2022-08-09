//
//  BoardView.swift
//  SysVPN
//
//  Created by Phan Văn Đa on 17/12/2021.
//

import SwiftUI

struct BoardView: View {
    
    @StateObject var viewModel: BoardViewModel
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authentication: Authentication
    @ObservedObject var selection = SelectionHandler()
    
    @State var showAccount = false
    @State var showSettings = false
    @State var showBoardList = false
    
    @State var showPopup = false
    
    var body: some View {
        ZStack {
            accountView()
                .opacity(showAccount ? 1 : 0)
            settingView()
                .opacity(showSettings ? 1 : 0)
            boardListView()
                .opacity(showBoardList ? 1 : 0)
            contentMapView()
                .opacity((!showAccount && !showSettings && !showBoardList) ? 1 : 0)
            if showBoardList {
                boardListView()
                    .transition(.move(edge: .bottom))
            }
            AutoConnectView(
                showSettings: .constant(true),
                showVPNSetting: .constant(true),
                shouldHideAutoConnect: $viewModel.shouldHideAutoConnect,
                statusConnect: $viewModel.stateUI,
                viewModel: AutoConnectViewModel())
            .opacity(viewModel.shouldHideAutoConnect ? 0 : 1)
            SessionVPNView(
                showAccount: .constant(true),
                showTotalDevice: .constant(true),
                statusConnect: $viewModel.stateUI,
                viewModel: SessionVPNViewModel(),
                shouldHideSessionList: $viewModel.shouldHideSession)
            .opacity(viewModel.shouldHideSession ? 0 : 1)
            VStack{
                Spacer()
                ToastView(title: viewModel.error?.title ?? "",
                          message: viewModel.error?.description ?? "",
                          cancelAction: {
                    viewModel.showAlert = false
                })
                .frame(alignment: .bottom)
                .padding(.bottom, 20)
            }
            .opacity(viewModel.showAlert ? 1 : 0)
            .onChange(of: viewModel.showAlert, perform: { newValue in
                if newValue {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        viewModel.showAlert = false
                    }
                }
            })
            VStack{
                Spacer()
                ToastView(title: "Need terminal some sessions",
                          message: "",
                          confirmTitle: "Open Sessions",
                          oneChossing: true,
                          confirmAction: {
                    viewModel.showAlertSessionSetting = false
                    viewModel.shouldHideSession = false
                })
                .frame(alignment: .bottom)
                .padding(.bottom, 20)
            }
            .opacity(viewModel.showAlertSessionSetting ? 1 : 0)
            .onChange(of: viewModel.showAlertSessionSetting, perform: { newValue in
                if newValue {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        viewModel.showAlertSessionSetting = false
                    }
                }
            })
            VStack{
                Spacer()
                ToastView(title: "Disable auto-conenct",
                          message: "",
                          confirmTitle: "Open Setting",
                          oneChossing: true,
                          confirmAction: {
                    viewModel.showAlertAutoConnectSetting = false
                    viewModel.shouldHideAutoConnect = false
                })
                .frame(alignment: .bottom)
                .padding(.bottom, 20)
            }
            .opacity(viewModel.showAlertAutoConnectSetting ? 1 : 0)
            .onChange(of: viewModel.showAlertAutoConnectSetting, perform: { newValue in
                if newValue {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        viewModel.showAlertAutoConnectSetting = false
                    }
                }
            })
        }
               .onChange(of: viewModel.nodeConnected, perform: { newValue in
                   showAccount = false
                   showSettings = false
                   showBoardList = false
               })
               .onChange(of: viewModel.staticIPNodeSelecte, perform: { newValue in
                   showAccount = false
                   showSettings = false
                   showBoardList = false
               })
               .onChange(of: viewModel.multihopSelect, perform: { newValue in
                   showAccount = false
                   showSettings = false
                   showBoardList = false
               })
               .animation(Animation.linear(duration: 0.25))
               .preferredColorScheme(.dark)
               .navigationBarHidden(true)
               .edgesIgnoringSafeArea(.all)
    }
    
    func handlerTapLeftNavigation() {
        showSettings = true
    }
    
    func handlerTapRightNavigation() {
        showAccount = true
    }
    
    func accountView() -> some View {
        AccountView(showAccount: $showAccount,
                    statusConnect: $viewModel.stateUI, viewModel: AccountViewModel())
    }
    
    func settingView() -> some View {
        SettingsView(showSettings: $showSettings,
                     statusConnect: $viewModel.stateUI,
                     showAutoConnect: $viewModel.showAutoConnect,
                     showProtocolConnect: $viewModel.showProtocolConnect,
                     showDNSSetting: $viewModel.showDNSSetting)
    }
    
    func boardListView() -> some View {
        BoardListView(showBoardList: $showBoardList,
                      currentTab: $viewModel.tab,
                      node: $viewModel.nodeConnected,
                      locationData: $viewModel.locationData,
                      staticIPData: $viewModel.staticIPData,
                      staticNode: $viewModel.staticIPNodeSelecte,
                      mutilhopList: $viewModel.mutilhopList,
                      multihopSelect: $viewModel.multihopSelect)
    }
    
    @State var zoomLogo = false
    
    func contentMapView() -> some View {
        ZStack(alignment: .top) {
            GeometryReader { geometry in
                ZStack {
                    MapView(mesh: viewModel.mesh,
                            selection: selection,
                            statusConnect: $viewModel.stateUI)
                    .allowsHitTesting(viewModel.stateUI != .connected)
                    if viewModel.stateUI == .connected {
                        Asset.Assets.logoConnectedBackground.swiftUIImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Asset.Assets.logoConnected.swiftUIImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                            .scaleEffect(zoomLogo ? 0.9 : 1.1)
                            .onAppear {
                                zoomLogo = !zoomLogo
                            }
                            .animation(Animation.easeInOut(duration: 0.7).repeatForever(autoreverses: true))
                    }
                }
                VStack {
                    BoardNavigationView(status: viewModel.stateUI,
                                        tapLeftIcon: {
                        handlerTapLeftNavigation()
                    }, tapRightIcon: {
                        handlerTapRightNavigation()
                    })
                    StatusVPNView(ip: viewModel.ip, status: viewModel.stateUI, flag: viewModel.flag, name: viewModel.nameSelect)
                    Spacer()
                    ConnectButton(status: viewModel.stateUI,
                                  uploadSpeed: viewModel.uploadSpeed,
                                  downloadSpeed: viewModel.downloadSpeed)
                    .onTapGesture {
                        viewModel.connectOrDisconnectByUser = true
                        viewModel.ConnectOrDisconnectVPN()
                    }
                    Spacer()
                        .frame(height: Constant.Board.Tabs.topPadding)
                    BoardTabView(tab: $viewModel.tab, showBoardList: $showBoardList)
                        .padding(.bottom)
                }
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            }
            if viewModel.showProgressView {
                // dont show loading
            }
        }
        .background(AppColor.background)
        .frame(alignment: .top)
        .animation(nil)
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(viewModel: BoardViewModel())
    }
}