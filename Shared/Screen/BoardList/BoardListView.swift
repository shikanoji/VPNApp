//
//  BoardListView.swift
//  SysVPN
//
//  Created by Da Phan Van on 19/01/2022.
//

import SwiftUI

struct BoardListView: View {
    @Binding var showBoardList: Bool
    @Binding var currentTab: BoardViewModel.StateTab
    @Binding var node: Node?
    
    @Binding var locationData: [NodeGroup]
    
    @Binding var staticIPData: [StaticServer]
    @Binding var staticNode: StaticServer?
    
    @Binding var mutilhopList: [MultihopModel]
    @Binding var multihopSelect: MultihopModel?
    
    @State var stopAnimation = false
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
                .frame(height: 20)
            StatusLocationView(node: node)
                .onTapGesture {
                    showBoardList = false
                }
            BoardTabView(tab: $currentTab, showBoardList: $showBoardList)
                .padding([.leading, .trailing])
            Spacer()
                .frame(height: 8)
            switch currentTab {
            case .location:
                LocationListView(locationData: $locationData, nodeSelect: $node, showAutoConnectionDestinationView: .constant(false))
            case .staticIP:
                StaticIPListView(staticIPData: $staticIPData, selectStaticServer: $staticNode)
            case .multiHop:
                MultiHopView(mutilhopList: $mutilhopList,
                              multihopSelect: $multihopSelect)
            }
        }
        .frame(maxHeight: .infinity)
        .navigationBarHidden(true)
        .background(AppColor.background)
        .ignoresSafeArea()
//        .onAppear {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                self.stopAnimation = true
//            }
//        }
//        .animation(stopAnimation ? nil : .linear)
    }
}
