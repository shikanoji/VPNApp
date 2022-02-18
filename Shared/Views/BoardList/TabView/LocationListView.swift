//
//  LocationListView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 08/02/2022.
//

import SwiftUI

struct LocationListView: View {
    @Binding var nodeLocation: NodeTab
    @Binding var nodeSelect: Node?
    @State var searchText = ""
    @State var isEditing = false
    @State var showCityListView = false
    @State var cityNode: Node?
    
    var body: some View {
        VStack(spacing: 8) {
            SearchBar(text: $searchText, isEditing: $isEditing)
                .padding(.horizontal)
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    if isEditing {
                        ForEach(nodeListSearch) { node in
                            NodeCellView(node: node)
                        }
                    } else {
                        ForEach(nodeLocation.dataLocations) { nodeListResult in
                            Text(nodeListResult.typeList.title)
                                .foregroundColor(AppColor.lightBlackText)
                                .font(Constant.BoardList.fontNodeList)
                                .padding(.leading)
                            ForEach(nodeListResult.nodeList) { node in
                                Button(action: {
                                    if node.cityNodeList.count > 0 {
                                        cityNode = node
                                        showCityListView = true
                                    } else {
                                        nodeSelect = node
                                    }
                                }) {
                                    NodeCellView(node: node)
                                }
                            }
                        }
                    }
                }
            }
            Spacer()
            NavigationLink(destination: CityListView(nodeSelect: $nodeSelect, node: cityNode ?? Node.country), isActive: $showCityListView) { }
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
            for i in 0..<nodeLocation.dataLocations.count {
                if nodeLocation.dataLocations[i].typeList == .all {
                    allNode += nodeLocation.dataLocations[i].nodeList
                }
            }
            return allNode.filter {
                //                $0.name.contains(searchText)
                $0.name.range(of: searchText, options: .caseInsensitive) != nil
            }
        }
    }
}

struct LocationListView_Previews: PreviewProvider {
    @State static var nodeTabList = NodeTab.location
    @State static var nodeSelect: Node? = nil
    
    static var previews: some View {
        LocationListView(nodeLocation: $nodeTabList, nodeSelect: $nodeSelect)
    }
}
