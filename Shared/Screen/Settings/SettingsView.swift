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
        ZStack {
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
                            .animation(nil)
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
    }
    
    var sectionsView: some View {
        ForEach(sections, id: \.id) { section in
            VStack(alignment: .leading) {
                Text(section.type.title)
                    .font(Constant.Menu.fontSectionTitle)
                    .foregroundColor(AppColor.lightBlackText)
                VStack {
                    ForEach(section.type.items) { item in
                        ItemRowView(item: item).onTapGesture {
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
                        }
                    }
                }
            }
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

