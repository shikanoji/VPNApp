//
//  BoardListView.swift
//  SysVPN
//
//  Created by Da Phan Van on 19/01/2022.
//

import SwiftUI
import TunnelKitManager
import TunnelKitCore

struct BoardListView: View {
    @StateObject var viewModel: BoardViewModel
    @Binding var nodeSelect: Node?
    
    @Binding var locationData: [NodeGroup]
    
    @Binding var staticIPData: [StaticServer]
    @Binding var staticIPSelect: StaticServer?
    
    @Binding var mutilhopList: [MultihopModel]
    @Binding var multihopSelect: MultihopModel?
    @Binding var statusConnect: VPNStatus
    
    @Binding var flag: String
    @Binding var name: String
    
    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                StatusLocationView(statusConnect: $statusConnect,
                                   flag: $flag,
                                   name: $name)
                    .onTapGesture {
                        withAnimation {
                            viewModel.configShowBoardList(false)
                        }
                    }
                    .padding(.top, UIDevice.current.userInterfaceIdiom == .pad ? 10 : 0)
                BoardTabView(viewModel: viewModel)
                    .padding([.leading, .trailing])
                Spacer()
                    .frame(height: 8)
                switch viewModel.selectedTab {
                case .location:
                    LocationListView(locationData: $locationData, nodeSelect: $nodeSelect)
                case .staticIP:
                    StaticIPListView(staticIPData: $staticIPData, selectStaticServer: $staticIPSelect)
                case .multiHop:
                    MultiHopView(mutilhopList: $mutilhopList,
                                 multihopSelect: $multihopSelect)
                }
            }
            .frame(maxHeight: .infinity)
            .navigationBarHidden(true)
            .background(AppColor.background)
            .ignoresSafeArea()
        }
    }
}
