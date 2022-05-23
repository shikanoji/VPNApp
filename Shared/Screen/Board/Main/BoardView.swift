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
        }
        .popup(isPresented: $viewModel.showAlert, type: .floater(verticalPadding: 10), position: .bottom, animation: .easeInOut, autohideIn: 10, closeOnTap: false, closeOnTapOutside: true) {
            ToastView(title: viewModel.error?.title ?? "",
                      message: viewModel.error?.description ?? "",
                      cancelAction: {
                viewModel.showAlert = false
            })
        }
        .onChange(of: viewModel.nodeConnected, perform: { newValue in
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
                    statusConnect: $viewModel.state, viewModel: AccountViewModel())
    }
    
    func settingView() -> some View {
        SettingsView(showSettings: $showSettings,
                     statusConnect: $viewModel.state)
    }
    
    func boardListView() -> some View {
        BoardListView(showBoardList: $showBoardList,
                      currentTab: $viewModel.tab,
                      node: $viewModel.nodeConnected,
                      locationData: $viewModel.locationData,
                      staticIPData: $viewModel.staticIPData,
                      staticNode: $viewModel.staticIPNodeSelecte,
                      multihopData: $viewModel.mutilhopData,
                      entryNodeList: $viewModel.entryNodeListMutilhop,
                      exitNodeList: $viewModel.exitNodeListMutilhop,
                      entryNodeSelect: $viewModel.entryNodeSelectMutilhop,
                      exitNodeSelect: $viewModel.exitNodeSelectMutilhop)
    }
    
    func contentMapView() -> some View {
        ZStack(alignment: .top) {
            GeometryReader { geometry in
                ZStack {
                    MapView(mesh: viewModel.mesh,
                            selection: selection,
                            statusConnect: $viewModel.state)
                    if viewModel.state == .connected {
                        Asset.Assets.logoConnected.SuImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }
                VStack {
                    BoardNavigationView(status: viewModel.state,
                                        tapLeftIcon: {
                        handlerTapLeftNavigation()
                    }, tapRightIcon: {
                        handlerTapRightNavigation()
                    })
                    StatusVPNView(ip: viewModel.ip, status: viewModel.state, flag: viewModel.flag)
                    Spacer()
                    ConnectButton(status: viewModel.state,
                                  uploadSpeed: viewModel.uploadSpeed,
                                  downloadSpeed: viewModel.downloadSpeed)
                        .onTapGesture {
                            viewModel.connectVPN()
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
