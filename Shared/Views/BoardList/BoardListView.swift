//
//  BoardListView.swift
//  SysVPN
//
//  Created by Da Phan Van on 19/01/2022.
//

import SwiftUI

struct BoardListView: View {
    @Binding var nodeTabList: [NodeTab]
    @Binding var showBoardList: Bool
    @Binding var currentTab: BoardViewModel.StateTab
    @Binding var node: Node?
    
    @Binding var nodeStaticList: [Node]
    @Binding var nodeMultihop: [(Node, Node)]
    
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
                LocationListView(nodeLocation: $nodeTabList[0], nodeSelect: $node)
            case .staticIP:
                StaticIPListView(nodeStaticList: $nodeStaticList, nodeSelect: $node)
            case .multiHop:
                 MultiHopView(nodeRecentList: $nodeMultihop,
                              entryNodeList: $entryNodeList,
                              exitNodeList: $exitNodeList,
                              entryNodeSelect: $entryNodeSelect,
                              exitNodeSelect: $exitNodeSelect)
            }
            Spacer()
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
    @State static var nodeTabList: [NodeTab] = NodeTab.example
    @State static var nodeMultihop =  [(Node.country, Node.tokyo), (Node.country, Node.tokyo)]
    @State static var nodeStaticList = Node.cityNodeList
    @State static var nodeList = Node.all
    @State static var nodeSelectMultihop1 = Node.country
    @State static var nodeSelectMultihop2 = Node.tokyo
    
    static var previews: some View {
        BoardListView(nodeTabList: $nodeTabList,
                      showBoardList: $show,
                      currentTab: Binding<BoardViewModel.StateTab>.constant(.location),
                      node: $node,
                      nodeStaticList: $nodeList,
                      nodeMultihop: $nodeMultihop,
                      entryNodeList: $nodeList,
                      exitNodeList: $nodeList,
                      entryNodeSelect: $nodeSelectMultihop1,
                      exitNodeSelect: $nodeSelectMultihop2)
    }
}
