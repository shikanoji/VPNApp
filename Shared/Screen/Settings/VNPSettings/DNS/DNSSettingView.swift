//
//  DNSSettingView.swift
//  SysVPN (iOS)
//
//  Created by Nguyen Dinh Thach on 30/05/2022.
//

import Foundation
import SwiftUI
import ExytePopupView

enum DNSSetting: String {
    case system = "default"
    case custom = "custom"
}

struct StaticOptionCell: View {
    let title: String
    let position: PositionItemCell
    @Binding var isOn: Bool
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(Constant.Menu.fontItem)
            }
            .padding(.leading, 16.0)
            Spacer()
            Toggle(isOn: $isOn, label: {})
                .toggleStyle(SelectToggleStyle())
                .padding(.trailing, 15.0)
        }
        .padding(.vertical, 8.0)
        .frame(minHeight: Constant.Menu.heightItemMenu)
        .frame(maxWidth: .infinity)
        .background(AppColor.darkButton)
        .cornerRadius(radius: Constant.Menu.radiusCell, corners: [position.rectCorner])
    }
}

struct DNSSettingView: View {
    @Binding var showSettings: Bool
    @Binding var showDNSSetting: Bool
    @StateObject var viewModel: DNSSettingViewModel
    @State var statusConnect: BoardViewModel.StateBoard = .connected
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var dnsSetting: DNSSetting {
        didSet {
            AppSetting.shared.dnsSetting = dnsSetting
        }
    }
    private let componentWidth = UIScreen.main.bounds.width - 2 * Constant.Menu.hozitalPaddingCell
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
                        showSettings = false
                        showDNSSetting = false
                    }, statusConnect: statusConnect)
                VStack(alignment: .leading, spacing: 1) {
                    StaticOptionCell(title: L10n.Settings.Dns.default,
                                     position: .top,
                                     isOn: $viewModel.selectedDefaultDns)
                    
                    StaticOptionCell(title: L10n.Settings.Dns.custom,
                                     position: .bot,
                                     isOn: $viewModel.selectedCustomDns)
                }
                .onChange(of: viewModel.selectedValue) { value in
                    dnsSetting = value
                }
                .padding(Constant.Menu.hozitalPaddingCell)
                .padding(.top, Constant.Menu.topPaddingCell)
                if viewModel.selectedCustomDns {
                    Form(placeholder: L10n.Settings.Dns.title,
                         value: $viewModel.customDNSValue,
                         width: componentWidth)
                    Spacer().frame(height: 20)
                    AppButton(style: .themeButton,
                              width: componentWidth,
                              text: L10n.Settings.Dns.save,
                              action: {
                        AppSetting.shared.customDNSValue = viewModel.customDNSValue
                        viewModel.alertMessage = L10n.Global.saveSuccess
                        viewModel.showAlert = true
                    })
                }
            }
        }
        .navigationBarHidden(true)
        .background(AppColor.background)
        .ignoresSafeArea()
        .popup(isPresented: $viewModel.showAlert, type: .floater(verticalPadding: 10), position: .bottom, animation: .easeInOut, autohideIn: 10, closeOnTap: false, closeOnTapOutside: true) {
            ToastView(title: viewModel.alertTitle,
                      message: viewModel.alertMessage,
                      cancelAction: {
                viewModel.showAlert = false
            })
        }
    }
}
