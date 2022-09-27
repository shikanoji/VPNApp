//
//  SelectLocationMultihopView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 09/02/2022.
//

import SwiftUI

struct SelectLocationMultihopView: View {
    @Binding var nodeList: [Node]
    @State var leftText: String = ""
    @State var nodeSelect: Node?
    
    @State var searchText = ""
    @State var isEditing = false
    @State var showCityListView = false
    @State var cityNode: Node? = nil
    
    var nodeSelectClosure: (Node) -> ()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
                .frame(height: 20)
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack {
                    Image(Constant.CustomNavigation.iconLeft)
                    Text(leftText)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                    Spacer()
                }
            }
            .padding()
            
            SearchBar(text: $searchText, isEditing: $isEditing)
                .padding(.horizontal)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    if isEditing {
                        ForEach(nodeListSearch) { node in
                            NodeCellView(node: node)
//                            NodeCellStaticView(node: node)
                        }
                    } else {
                        ForEach(nodeList) { node in
                            Button(action: {
                                if node.cityNodeList.count > 0 {
                                    cityNode = node
                                    showCityListView = true
                                } else {
                                    AppSetting.shared.temporaryDisableAutoConnect = false
                                    if ItemCell(type: AppSetting.shared.getAutoConnectProtocol()).type == .off {
                                        nodeSelect = node
                                    }
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }) {
                                NodeCellView(node: node)
//                                NodeCellStaticView(node: node)
                            }
                        }
                    }
                }
            }
            Spacer()
            NavigationLink(destination: CityListView(nodeSelect: $nodeSelect,
                                                     node: cityNode ?? Node.country),
                           isActive: $showCityListView) { }
        }
        .onChange(of: nodeSelect, perform: { newValue in
            guard let exitNode = newValue else {
                return
            }
            nodeSelectClosure(exitNode)
            presentationMode.wrappedValue.dismiss()
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarHidden(true)
        .background(AppColor.background)
        .ignoresSafeArea()
    }
    
    var nodeListSearch: [Node] {
        if searchText.isEmpty {
            return nodeList
        } else {
            return nodeList.filter {
                //                $0.name.contains(searchText)
                $0.name.range(of: searchText, options: .caseInsensitive) != nil
            }
        }
    }
}
