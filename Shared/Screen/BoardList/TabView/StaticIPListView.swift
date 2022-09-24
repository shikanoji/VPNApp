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
                    Text(L10n.StaticIP.staticIP)
                        .foregroundColor(AppColor.lightBlackText)
                        .font(.system(size: 12))
                    Spacer()
                    Text(L10n.StaticIP.currentLoad)
                        .foregroundColor(AppColor.backgroundStatusView)
                        .font(.system(size: 9))
                }
                .padding([.top, .leading, .trailing])
                VStack(alignment: .leading) {
                    if isEditing {
                        ForEach(nodeListSearch) { node in
                            Button(action: {
                                selectStaticServer = node
                                NotificationCenter.default.post(name: Constant.NameNotification.showMap, object: nil)
                            }) {
                                NodeCellStaticView(node: node)
                            }
                        }
                    } else {
                        ForEach(staticIPData) { node in
                            Button(action: {
                                selectStaticServer = node
                                NotificationCenter.default.post(name: Constant.NameNotification.showMap, object: nil)
                            }) {
                                NodeCellStaticView(node: node)
                            }
                        }
                    }
                }
                .padding([.leading, .bottom, .trailing])
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
            return staticIPData
        } else {
            return staticIPData.filter {
                AppSetting.shared.isExitSearch(searchText, name: $0.countryName, iso2: $0.iso2, iso3: $0.iso3)
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
