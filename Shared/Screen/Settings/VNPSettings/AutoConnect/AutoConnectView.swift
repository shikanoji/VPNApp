//
//  AutoConnectView.swift
//  SysVPN
//
//  Created by Da Phan Van on 19/01/2022.
//

import SwiftUI
import TunnelKitManager

struct AutoConnectView: View {
    @Binding var showSettings: Bool
    @Binding var showVPNSetting: Bool
    @Binding var shouldHideAutoConnect: Bool
    
    var statusConnect: VPNStatus
    var sectionList: [SectionCell] = []
    @StateObject var viewModel: AutoConnectViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
        
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack() {
                AppColor.darkButton
                    .frame(height: 10)
                CustomNavigationView(
                    leftTitle: L10n.Settings.itemVPN,
                    currentTitle: L10n.Settings.itemAuto,
                    tapLeftButton: {
                        presentationMode.wrappedValue.dismiss()
                        shouldHideAutoConnect = true
                    }, tapRightButton: {
                        showVPNSetting = false
                        showSettings = false
                        shouldHideAutoConnect = true
                    }, statusConnect: statusConnect)
                VStack(alignment: .leading, spacing: 1) {
                    ForEach(viewModel.sectionList, id: \.id) { section in
                        if section.type.title != "" {
                            Text(section.type.title)
                                .padding(.vertical)
                                .foregroundColor(AppColor.lightBlackText)
                                .font(Font.system(size: 12))
                        }
                        ForEach(section.items, id: \.id) { item in
                            ItemRowCell(title: item.type.title,
                                        content: item.type.content,
                                        showRightButton: item.type.showRightButton,
                                        showSwitch: item.type.showSwitch,
                                        showSelect: item.type.showSelect,
                                        position: getPosition(item: item, arr: section.items),
                                        switchValue: item.select,
                                        onSwitchValueChange: { value in
                                if value {
                                    viewModel.updateItem(item: item)
                                }
                            })
                            .environmentObject(viewModel)
                        }
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
