//
//  StaticIPListView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 09/02/2022.
//

import SwiftUI

struct StaticIPListView: View {
    @Binding var staticIPData: [StaticServer]
    @Binding var selectStaticServer: StaticServer?
    @State var searchText = ""
    @State var isEditing = false
    
    var body: some View {
        VStack(spacing: 8) {
            SearchBar(text: $searchText, isEditing: $isEditing)
                .padding(.horizontal)
            ScrollView(showsIndicators: false) {
                HStack {
                    Text(LocalizedStringKey.StaticIP.staticIP.localized)
                        .foregroundColor(AppColor.lightBlackText)
                        .font(.system(size: 12))
                    Spacer()
                    Text(LocalizedStringKey.StaticIP.currentLoad.localized)
                        .foregroundColor(AppColor.backgroundStatusView)
                        .font(.system(size: 9))
                }
                .padding(.all)
                VStack(alignment: .leading) {
                    if isEditing {
                        ForEach(nodeListSearch) { node in
                            NodeCellStaticView(node: node)
                        }
                    } else {
                        ForEach(staticIPData) { node in
                            Button(action: {
                                selectStaticServer = node
                            }) {
                                NodeCellStaticView(node: node)
                            }
                        }
                    }
                }
                .padding()
            }
            Spacer()
        }
        .frame(maxHeight: .infinity)
        .navigationBarHidden(true)
        .background(AppColor.background)
        .ignoresSafeArea()
    }
    
    var nodeListSearch: [StaticServer] {
        if searchText.isEmpty {
            return []
        } else {
            return staticIPData.filter {
                //                $0.name.contains(searchText)
                $0.name.range(of: searchText, options: .caseInsensitive) != nil
            }
        }
    }
}

struct StaticIPListView_Previews: PreviewProvider {
    @State static var nodeStaticList = [StaticServer()]
    @State static var nodeSelect: StaticServer? = nil
    
    static var previews: some View {
        StaticIPListView(staticIPData: $nodeStaticList, selectStaticServer: $nodeSelect)
    }
}
