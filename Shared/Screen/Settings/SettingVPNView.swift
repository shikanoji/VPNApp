//
//  SettingVPNView.swift
//  SysVPN
//
//  Created by Da Phan Van on 19/01/2022.
//

import SwiftUI

struct SettingVPNView: View {
    @Binding var showSettings: Bool
    @Binding var showVPNSetting: Bool
    
    @State var statusConnect: BoardViewModel.StateBoard = .connected
    @State var showAutoConnect = false
    @State var showProtocolConnect = false
    @State var itemList: [ItemCellType] = [
        .autoConnet,
        .protocolConnect,
        .split,
        .dns,
        .localNetwork,
        .metered
    ]
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                AppColor.darkButton
                    .frame(height: 10)
                CustomNavigationView(
                    leftTitle: L10n.Settings.title,
                    currentTitle: L10n.Settings.itemVPN,
                    tapLeftButton: {
                        presentationMode.wrappedValue.dismiss()
                    }, tapRightButton: {
                        showSettings = false
                        presentationMode.wrappedValue.dismiss()
                    }, statusConnect: statusConnect)
                VStack(spacing: 1) {
                    ForEach(itemList.indices) { i in
                        ItemRowCell(title: itemList[i].title,
                                    content: itemList[i].content,
                                    showSwitch: itemList[i].showSwitch,
                                    position: itemList.getPosition(i))
                            .onTapGesture {
                                switch itemList[i] {
                                case .autoConnet:
                                    showAutoConnect = true
                                case .protocolConnect:
                                    showProtocolConnect = true
                                default:
                                    return
                                }
                            }
                    }
                }
                .padding(Constant.Menu.hozitalPaddingCell)
                .padding(.top, Constant.Menu.topPaddingCell)
                Spacer().frame(height: 20)
            }
            NavigationLink(destination:
                            AutoConnectView(
                                showSettings: $showSettings,
                                showVPNSetting: $showVPNSetting,
                                statusConnect: statusConnect),
                           isActive: $showAutoConnect) { }
            NavigationLink(destination:
                            ProtocolSettingView(
                                showSettings: $showSettings,
                                showVPNSetting: $showVPNSetting,
                                viewModel: ProtocolSettingViewModel()),
                           isActive: $showProtocolConnect) { }
        }
        .navigationBarHidden(true)
        .background(AppColor.background)
        .ignoresSafeArea()
    }
}


struct SettingVPNView_Previews: PreviewProvider {
    @State static var showAccount = true
    
    static var previews: some View {
        SettingVPNView(showSettings: $showAccount, showVPNSetting: $showAccount)
    }
}
