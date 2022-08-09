//
//  LocationListView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 08/02/2022.
//

import SwiftUI

struct LocationListView: View {
    @Binding var locationData: [NodeGroup]
    @Binding var nodeSelect: Node?
    @State var searchText = ""
    @State var isEditing = false
    @State var showCityListView = false
    @State var cityNode: Node?
    var hasFastestOption: Bool = false
    @Binding var showAutoConnectionDestinationView: Bool
    var fastestServerSection: some View {
            VStack {
                HStack {
                    Spacer().frame(width: 16)
                    Text("Favorites")
                        .font(Constant.BoardList.fontNodeList)
                        .foregroundColor(AppColor.lightBlackText)
                    Spacer()
                }
                HStack(spacing: 16) {
                    Asset.Assets.fastestServerIcon.swiftUIImage
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Fastest server")
                            .font(Constant.BoardList.fontNameCity)
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding()
                .frame(height: Constant.BoardList.heightStatusLoction)
                .onTapGesture {
                    nodeSelect = nil
                }
            }
        }
    var body: some View {
        VStack(spacing: 8) {
            SearchBar(text: $searchText, isEditing: $isEditing)
                .padding(.horizontal)
            if hasFastestOption  {
                Spacer().frame(height: 20)
                fastestServerSection
            }
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    if isEditing {
                        ForEach(nodeListSearch) { node in
                            NodeCellView(node: node)
                        }
                    } else {
                        ForEach(locationData, id: \.type) { nodeList in
                            Text(nodeList.type?.title ?? "")
                                .foregroundColor(AppColor.lightBlackText)
                                .font(Constant.BoardList.fontNodeList)
                                .padding([.top, .leading])
                            ForEach(nodeList.list) { node in
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
            NavigationLink(destination: CityListView(nodeSelect: $nodeSelect,
                                                     node: cityNode ?? Node.country,
                                                     showAutoConnectDestinationView: $showAutoConnectionDestinationView), isActive: $showCityListView) { }
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
            for i in 0..<locationData.count {
                if locationData[i].type == .all {
                    allNode += locationData[i].list
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
    @State static var locationData: [NodeGroup] = [NodeGroup.init(nodeList: Node.cityNodeList, type: .all)]
    @State static var nodeSelect: Node? = nil
    
    static var previews: some View {
        LocationListView(locationData: $locationData, nodeSelect: $nodeSelect, showAutoConnectionDestinationView: .constant(false))
    }
}