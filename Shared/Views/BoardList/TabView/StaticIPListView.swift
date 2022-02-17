//
//  StaticIPListView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 09/02/2022.
//

import SwiftUI

struct StaticIPListView: View {
    @Binding var nodeStaticList: [Node]
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
                            NodeCellStaticView(node: node)
                        }
                    } else {
                        ForEach(nodeStaticList) { node in
                            Button(action: {
                                if node.cityNodeList.count > 0 {
                                    cityNode = node
                                    showCityListView = true
                                } else {
                                    nodeSelect = node
                                }
                            }) {
                                NodeCellStaticView(node: node)
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
            return nodeStaticList.filter {
                //                $0.name.contains(searchText)
                $0.name.range(of: searchText, options: .caseInsensitive) != nil
            }
        }
    }
}

struct StaticIPListView_Previews: PreviewProvider {
    @State static var nodeStaticList = Node.cityNodeList
    @State static var nodeSelect: Node? = nil
    
    static var previews: some View {
        StaticIPListView(nodeStaticList: $nodeStaticList, nodeSelect: $nodeSelect)
    }
}
