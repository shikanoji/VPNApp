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
    @State var searchText = ""
    @State var isEditing = false
    
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
            SearchBar(text: $searchText, isEditing: $isEditing)
                .padding(.horizontal)
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    if isEditing {
                        ForEach(nodeListSearch) { node in
                            NodeCellView(node: node)
                        }
                    } else {
                        ForEach(nodeTabList) { nodeTab in
                            if nodeTab.state == currentTab {
                                ForEach(nodeTab.data) { nodeListResult in
                                    Text(nodeListResult.typeList.title)
                                        .foregroundColor(AppColor.lightBlackText)
                                        .font(Constant.BoardList.fontNodeList)
                                        .padding()
                                    ForEach(nodeListResult.nodeList) { node in
                                        NodeCellView(node: node)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            Spacer()
        }
        .frame(maxHeight: .infinity)
        .navigationBarHidden(true)
        .background(AppColor.background)
        .ignoresSafeArea()
    }
    
    var nodeListSearch: [Node] {
        if searchText.isEmpty {
            return []
        } else {
            var allNode: [Node] = []
            if let currentNodeTab = nodeTabList.filter({
                $0.state == currentTab
            }).first {
                for i in 0..<currentNodeTab.data.count {
                    if currentNodeTab.data[i].typeList == .all {
                        allNode += currentNodeTab.data[i].nodeList
                    }
                }
            }
            return allNode.filter {
//                $0.name.contains(searchText)
                $0.name.range(of: searchText, options: .caseInsensitive) != nil
            }
        }
    }
}


struct BoardListView_Previews: PreviewProvider {
    @State static var show = true
    @State static var node: Node? = Node.simple1
    @State static var nodeTabList: [NodeTab] = NodeTab.example
    
    static var previews: some View {
        BoardListView(nodeTabList: $nodeTabList, showBoardList: $show, currentTab: Binding<BoardViewModel.StateTab>.constant(.location),
                      node: $node)
    }
}
