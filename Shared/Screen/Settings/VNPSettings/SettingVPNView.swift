//
//  SettingVPNView.swift
//  SysVPN
//
//  Created by Da Phan Van on 19/01/2022.
//

import SwiftUI
import TunnelKitManager

struct SettingVPNView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var showSettings: Bool
    @Binding var showVPNSetting: Bool
    
    @Binding var statusConnect: VPNStatus
    @State var showAutoConnect: Bool = false
    @State var showProtocolConnect: Bool = false
    @State var showDNSSetting: Bool = false
    
    @StateObject var viewModel: SettingVPNViewModel
    
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
                    }, statusConnect: $statusConnect)
                VStack(spacing: 1) {
                    ForEach(viewModel.itemList) { item in
                        ItemRowCell(title: item.type.title,
                                    content: item.type.content,
                                    showSwitch: item.type.showSwitch,
                                    position: getPosition(item: item, arr: viewModel.itemList))
                            .onTapGesture {
                                switch item.type {
                                case .autoConnect:
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
                                shouldHideAutoConnect: .constant(false),
                                statusConnect: $statusConnect,
                                viewModel: AutoConnectViewModel()),
                           isActive: $showAutoConnect) { }
                .isDetailLink(false)
            NavigationLink(destination:
                            ProtocolSettingView(
                                showSettings: $showSettings,
                                showVPNSetting: $showVPNSetting,
                                viewModel: ProtocolSettingViewModel(),
                                statusConnect: $statusConnect),
                           isActive: $showProtocolConnect) { }
            NavigationLink(destination:
                            DNSSettingView(showSettings: $showSettings,
                                           showDNSSetting: $showDNSSetting,
                                           viewModel: DNSSettingViewModel(),
                                           statusConnect: $statusConnect,
                                           dnsSetting: AppSetting.shared.dnsSetting),
                           isActive: $showDNSSetting) { }
        }
        .onAppear {
            viewModel.refreshItemList()
        }
        .navigationBarHidden(true)
        .background(AppColor.background)
        .ignoresSafeArea()
    }
}
