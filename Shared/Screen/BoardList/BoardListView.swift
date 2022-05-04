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
    
    @Binding var multihopData: [(Node, Node)]
    
    @Binding var entryNodeList: [Node]
    @Binding var exitNodeList: [Node]
    
    @Binding var entryNodeSelect: Node
    @Binding var exitNodeSelect: Node
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
                .frame(height: 20)
            StatusLocationView(node: node)
                .onTapGesture {
                    showBoardList = false
                }
            BoardTabView(tab: $currentTab, showBoardList: Binding.constant(false))
                .padding([.leading, .trailing])
            Spacer()
                .frame(height: 8)
            switch currentTab {
            case .location:
                LocationListView(locationData: $locationData, nodeSelect: $node)
            case .staticIP:
                StaticIPListView(staticIPData: $staticIPData, selectStaticServer: $staticNode)
            case .multiHop:
                 MultiHopView(nodeRecentList: $multihopData,
                              entryNodeList: $entryNodeList,
                              exitNodeList: $exitNodeList,
                              entryNodeSelect: $entryNodeSelect,
                              exitNodeSelect: $exitNodeSelect)
            }
        }
        .frame(maxHeight: .infinity)
        .navigationBarHidden(true)
        .background(AppColor.background)
        .ignoresSafeArea()
    }
}


struct BoardListView_Previews: PreviewProvider {
    @State static var show = true
    @State static var node: Node? = Node.country
    @State static var nodeTabList: [NodeGroup] = [NodeGroup.init(nodeList: Node.cityNodeList, type: .all)]
    @State static var nodeMultihop =  [(Node.country, Node.tokyo), (Node.country, Node.tokyo)]
    
    @State static var nodeStaticList = [StaticServer()]
    @State static var staticNode: StaticServer? = nil
    
    @State static var nodeList = Node.all
    @State static var nodeSelectMultihop1 = Node.country
    @State static var nodeSelectMultihop2 = Node.tokyo
    
    static var previews: some View {
        BoardListView(showBoardList: $show,
                      currentTab: Binding<BoardViewModel.StateTab>.constant(.location),
                      node: $node,
                      locationData: $nodeTabList,
                      staticIPData: $nodeStaticList,
                      staticNode: $staticNode,
                      multihopData: $nodeMultihop,
                      entryNodeList: $nodeList,
                      exitNodeList: $nodeList,
                      entryNodeSelect: $nodeSelectMultihop1,
                      exitNodeSelect: $nodeSelectMultihop2)
    }
}
