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
        VStack(spacing: 0.0) {
            if showAccount {
                AccountView(showAccount: $showAccount,
                            statusConnect: $viewModel.state, viewModel: AccountViewModel())
            } else if showSettings{
                SettingsView(showSettings: $showSettings,
                             statusConnect: $viewModel.state)
            } else if showBoardList {
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
            } else {
                ZStack(alignment: .top) {
                    GeometryReader { geometry in
                        MapView(mesh: viewModel.mesh,
                                selection: selection,
                                showCityNodes: $viewModel.showCityNodes,
                                configMapView: viewModel.configMapView)
                        VStack {
                            BoardNavigationView(status: viewModel.state,
                                                tapLeftIcon: {
                                handlerTapLeftNavigation()
                            }, tapRightIcon: {
                                handlerTapRightNavigation()
                            })
                            StatusVPNView(ip: viewModel.ip, status: viewModel.state)
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
                }
                .background(AppColor.background)
                .frame(alignment: .top)
            }
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
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(viewModel: BoardViewModel())
    }
}
