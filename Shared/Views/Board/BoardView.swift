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
    
    @ObservedObject var mesh = Mesh.sampleMesh()
    @ObservedObject var selection = SelectionHandler()
    
    var body: some View {
//        ZStack {
            VStack(spacing: 0.0) {
                ZStack(alignment: .top) {
                    GeometryReader { geometry in
                        MapView(mesh: mesh, selection: selection, showCityNodes: $viewModel.showCityNodes)
                        VStack {
                            BoardNavigationView(status: viewModel.state,
                                                tapLeftIcon: {
                                handlerTapLeftNavigation()
                            }, tapRightIcon: {
                                handlerTapRightNavigation()
                            })
                            StatusVPNView(ip: viewModel.ip, status: viewModel.state)
                            Button("Logout") {
                                authentication.logout()
                            }
                            Spacer()
                            ConnectButton(status: viewModel.state,
                                          uploadSpeed: viewModel.uploadSpeed,
                                          downloadSpeed: viewModel.downloadSpeed)
                                .onTapGesture {
                                    viewModel.getLocationAvaible()
                                }
                            BoardTabView(tab: $viewModel.tab)
                                .padding(.top, Constant.Board.Tabs.topPadding)
                        }
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    }
                }
                .background(AppColor.background)
                .frame(alignment: .top)
            }
            .preferredColorScheme(.dark)
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
//        }
    }
    
    func handlerTapLeftNavigation() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func handlerTapRightNavigation() {
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(viewModel: BoardViewModel())
    }
}
