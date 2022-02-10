//
//  SettingsView.swift
//  SysVPN
//
//  Created by Da Phan Van on 19/01/2022.
//

import SwiftUI

struct SettingsView: View {
    @Binding var showSettings: Bool
    
    @Binding var statusConnect: BoardViewModel.StateBoard
    @State var showVPNSetting = false
    
    @State var sections: [DataSection] = [
        DataSection(type: .vpnSetting),
        DataSection(type: .otherSetting)
    ]
    
    var body: some View {
        VStack {
            AppColor.darkButton
                .frame(height: 24)
            CustomNavigationView(
                tapLeftButton: {
                    showSettings = false
                }, tapRightButton: {
                    showSettings = false
                }, statusConnect: statusConnect)
            ScrollView(showsIndicators: false) {
                VStack {
                    ForEach(sections, id: \.id) { section in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(section.type.title)
                                .font(Constant.Menu.fontSectionTitle)
                                .foregroundColor(AppColor.lightBlackText)
                            ForEach(section.type.items) { item in
                                Button {
                                    switch item.type {
                                    case .vpnConnection:
                                        self.showVPNSetting = true
                                    default:
                                        return
                                    }
                                } label: {
                                    ItemRowView(item: item)
                                }
                            }
                        }
                    }
                    .padding([.top, .leading])
                    Spacer().frame(height: 34)
                    NavigationLink(destination: SettingVPNView(showSettings: $showSettings, statusConnect: statusConnect), isActive: $showVPNSetting) { }
                }
            }
            .frame(maxHeight: .infinity)
            .background(AppColor.background)
            .ignoresSafeArea()
        }
        .background(AppColor.background)
    }
}



struct SettingsView_Previews: PreviewProvider {
    
    @State static var showMenu = true
    @State static var value: BoardViewModel.StateBoard = .connected
    
    static var previews: some View {
        SettingsView(showSettings: $showMenu, statusConnect: $value)
    }
}
