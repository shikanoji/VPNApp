//
//  SettingsView.swift
//  SysVPN
//
//  Created by Da Phan Van on 19/01/2022.
//

import SwiftUI
import TunnelKitManager

struct SettingsView: View {
    @Binding var showSettings: Bool
    @Binding var statusConnect: VPNStatus
    
    @State var showVPNSetting = false
    @State var showToolsSetting = false
    @State var showLicenseList = false
    @State var showTermsAndCondition = false
    @State var showPrivacyPolicies = false
    @Binding var showAutoConnect: Bool
    @Binding var showProtocolConnect: Bool
    @Binding var showDNSSetting: Bool
    
    var sections: [DataSection] = [
        DataSection(type: .vpnSetting),
        DataSection(type: .otherSetting)
    ]
    
    var body: some View {
        VStack {
            AppColor.darkButton
                .frame(height: 14)
            CustomNavigationView(
                tapLeftButton: {
                    showSettings = false
                }, tapRightButton: {
                    showSettings = false
                }, statusConnect: $statusConnect)
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
                                    case .tools:
                                        self.showToolsSetting = true
                                    case .licenses:
                                        self.showLicenseList = true
                                    case .termAndConditions:
                                        self.showTermsAndCondition = true
                                    case .privacyPolicy:
                                        self.showPrivacyPolicies = true
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
                    Group {
                        NavigationLink(destination:
                                        SettingVPNView(
                                            showSettings: $showSettings,
                                            showVPNSetting: $showVPNSetting,
                                            statusConnect: $statusConnect,
                                            viewModel: SettingVPNViewModel()),
                                       isActive: $showVPNSetting) { }
                            .isDetailLink(false)
                        NavigationLink(destination:
                                        ToolsView(showSettings: $showSettings,
                                                  statusConnect: $statusConnect,
                                                  viewModel: ToolsViewModel()),
                                       isActive: $showToolsSetting) { }
                        NavigationLink(destination:
                                        LicenseListView(showSettings: $showSettings,
                                                        statusConnect: $statusConnect,
                                                        viewModel: LicenseListViewModel()),
                                       isActive: $showLicenseList) { }
                        NavigationLink(destination: EmbedWebView(url: Constant.api.termsAndConditionsURL,
                                                                 title: L10n.Settings.termAndCondition),
                                       isActive: $showTermsAndCondition) { }
                        NavigationLink(destination: EmbedWebView(url: Constant.api.privacyPolictyURL,
                                                                 title: L10n.Settings.privacyPolicty),
                                                               isActive: $showPrivacyPolicies) { }
                    }
                }
            }
            .frame(maxHeight: .infinity)
            .background(AppColor.background)
            .ignoresSafeArea()
        }
        .background(AppColor.background)
        .animation(nil)
    }
}

