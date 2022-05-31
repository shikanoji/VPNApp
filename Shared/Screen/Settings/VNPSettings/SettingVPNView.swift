//
//  SettingVPNView.swift
//  SysVPN
//
//  Created by Da Phan Van on 19/01/2022.
//

import SwiftUI
import TunnelKitManager

struct SettingVPNView: View {
    @Binding var showSettings: Bool
    @Binding var showVPNSetting: Bool
    @Binding var instantlyShowAutoConnect: Bool
    
    @State var statusConnect: VPNStatus = .connected
    @State var showAutoConnect = false
    @State var showProtocolConnect = false
    @State var showDNSSetting = false

    @State var itemList: [ItemCellType] = [
        .autoConnet,
        .protocolConnect,
        //.split,
        .dns,
        //.localNetwork,
        //.metered
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
                                case .dns:
                                    showDNSSetting = true
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
                                statusConnect: statusConnect,
                                viewModel: AutoConnectViewModel(),
                                instantlyShowAutoConnect: $instantlyShowAutoConnect),
                           isActive: $showAutoConnect) { }
            NavigationLink(destination:
                            ProtocolSettingView(
                                showSettings: $showSettings,
                                showVPNSetting: $showVPNSetting,
                                viewModel: ProtocolSettingViewModel()),
                           isActive: $showProtocolConnect) { }
            NavigationLink(destination:
                            DNSSettingView(showSettings: $showSettings,
                                           showDNSSetting: $showDNSSetting,
                                           viewModel: DNSSettingViewModel(),
                                           dnsSetting: AppSetting.shared.dnsSetting),
                           isActive: $showDNSSetting) { }
        }
        .navigationBarHidden(true)
        .background(AppColor.background)
        .ignoresSafeArea()
    }
}


struct SettingVPNView_Previews: PreviewProvider {
    @State static var showAccount = true
    
    static var previews: some View {
        SettingVPNView(showSettings: $showAccount, showVPNSetting: $showAccount, instantlyShowAutoConnect: $showAccount)
    }
}
