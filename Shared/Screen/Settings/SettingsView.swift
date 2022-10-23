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
        
    var body: some View {
        VStack {
            AppColor.darkButton
                .frame(height: 20)
            CustomNavigationView(
                tapLeftButton: {
                    showSettings = false
                }, tapRightButton: {
                    showSettings = false
                }, statusConnect: $statusConnect)
            ScrollView(showsIndicators: false) {
                VStack {
                    sectionsView
                        .padding([.top, .leading])
                    Spacer().frame(height: 34)
                    navigationLinks
                }
            }
            .frame(maxHeight: .infinity)
            .background(AppColor.background)
            .ignoresSafeArea()
        }
        .background(AppColor.background)
    }
    var sectionsView: some View {
        VStack(alignment: .leading) {
            Spacer().frame(height: 10)
            Text(L10n.Settings.sectionVPN)
                .font(Constant.Menu.fontSectionTitle)
                .foregroundColor(AppColor.lightBlackText)
            ItemRowView(item: ItemCell(type: .vpnConnection)).onTapGesture {
                self.showVPNSetting = true
            }
            ItemRowView(item: ItemCell(type: .tools)).onTapGesture {
                self.showToolsSetting = true
            }
            Spacer().frame(height: 25)
            Text(L10n.Settings.sectionOther)
                .font(Constant.Menu.fontSectionTitle)
                .foregroundColor(AppColor.lightBlackText)
            ItemRowView(item: ItemCell(type: .privacyPolicy)).onTapGesture {
                self.showPrivacyPolicies = true
            }
            ItemRowView(item: ItemCell(type: .termAndConditions)).onTapGesture {
                self.showTermsAndCondition = true
            }
            ItemRowView(item: ItemCell(type: .licenses)).onTapGesture {
                self.showLicenseList = true
            }
            ItemRowView(item: ItemCell(type: .currentVersion))
        }
    }

    var navigationLinks: some View {
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

