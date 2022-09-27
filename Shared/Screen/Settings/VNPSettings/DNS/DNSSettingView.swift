//
//  DNSSettingView.swift
//  SysVPN (iOS)
//
//  Created by Nguyen Dinh Thach on 30/05/2022.
//

import Foundation
import SwiftUI
import PopupView
import TunnelKitManager

enum DNSSetting: String {
    case system = "default"
    case custom = "custom"
}

struct DNSSettingView: View {
    @Binding var showSettings: Bool
    @Binding var showDNSSetting: Bool
    @StateObject var viewModel: DNSSettingViewModel
    @Binding var statusConnect: VPNStatus
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var dnsSetting: DNSSetting
    
    private let componentWidth = UIScreen.main.bounds.width - 2 * Constant.Menu.hozitalPaddingCell
    
    private var customDNSSection: some View {
        VStack {
            Spacer().frame(height: 30)
            HStack {
                Text(L10n.Settings.Dns.Custom.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color.white)
                Spacer()
            }.frame(width: componentWidth)
            Spacer().frame(height: 20)
            Form(placeholder: L10n.Settings.Dns.Custom.primaryDNS,
                 value: $viewModel.primaryDNSValue,
                 width: componentWidth)
            Spacer().frame(height: 20)
            Form(placeholder: L10n.Settings.Dns.Custom.secondaryDNS,
                 value: $viewModel.secondaryDNSValue,
                 width: componentWidth)
            Spacer().frame(height: 20)
            AppButton(style: .themeButton,
                      width: componentWidth,
                      text: L10n.Settings.Dns.save,
                      action: {
                viewModel.save()
            })
        }
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack() {
                AppColor.darkButton
                    .frame(height: 10)
                CustomNavigationView(
                    leftTitle: L10n.Settings.itemVPN,
                    currentTitle: L10n.Settings.Dns.title,
                    tapLeftButton: {
                        presentationMode.wrappedValue.dismiss()
                    }, tapRightButton: {
                        UINavigationBar.setAnimationsEnabled(false)
                        showSettings = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            UINavigationBar.setAnimationsEnabled(true)
                        }
                    }, statusConnect: $statusConnect)
                VStack(alignment: .leading, spacing: 1) {
                    ItemRowCell(title: L10n.Settings.Dns.default, content: L10n.Settings.Dns.Default.content, showSwitch: true,  position: .all, switchValue: viewModel.selectedDefaultDns, onSwitchValueChange: { value in
                        viewModel.selectedDefaultDns = value
                    })
                }
                .onChange(of: viewModel.selectedValue) { value in
                    dnsSetting = value
                }
                .padding(Constant.Menu.hozitalPaddingCell)
                .padding(.top, Constant.Menu.topPaddingCell)
                if !viewModel.selectedDefaultDns {
                    customDNSSection
                }
            }
        }
        .navigationBarHidden(true)
        .background(AppColor.background)
        .ignoresSafeArea()
        .popup(isPresented: $viewModel.showAlert, type: .floater(verticalPadding: 10), position: .bottom, animation: .easeInOut, autohideIn: 5, closeOnTap: false, closeOnTapOutside: true) {
            PopupSelectView(message: viewModel.alertMessage,
                            confirmAction: {
                viewModel.showAlert = false
            })
        }
    }
}
