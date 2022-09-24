//
//  ProtocolSettingView.swift
//  SysVPN
//
//  Created by Da Phan Van on 27/04/2022.
//

import SwiftUI
import TunnelKitManager

struct ProtocolSettingView: View {
    @Binding var showSettings: Bool
    @Binding var showVPNSetting: Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var viewModel: ProtocolSettingViewModel
    @Binding var statusConnect: VPNStatus
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack() {
                AppColor.darkButton
                    .frame(height: 10)
                CustomNavigationView(
                    leftTitle: L10n.Settings.itemVPN,
                    currentTitle: L10n.Settings.itemProtocol,
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
                    ForEach(viewModel.section.items) { item in
                        ItemRowCell(title: item.type.title,
                                    content: item.type.content,
                                    showRightButton: item.type.showRightButton,
                                    showSwitch: item.type.showSwitch,
                                    showSelect: item.type.showSelect,
                                    position: viewModel.section.items.getPosition(item),
                                    switchValue: item.select,
                                    onSwitchValueChange: { value in
                            if value {
                                viewModel.configItem(item)
                            }
                        })
                        .environmentObject(viewModel)
                    }
                }
                .padding(Constant.Menu.hozitalPaddingCell)
                .padding(.top, Constant.Menu.topPaddingCell)
            }
        }
        .navigationBarHidden(true)
        .background(AppColor.background)
        .ignoresSafeArea()
    }
}

struct ProtocolSettingView_Previews: PreviewProvider {
    @State static var show = true
    @State static var status: VPNStatus = .connected
    
    static var previews: some View {
        ProtocolSettingView(showSettings: $show, showVPNSetting: $show, viewModel: ProtocolSettingViewModel(), statusConnect: $status)
    }
}
