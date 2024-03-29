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
    @Binding var showAutoConnectView: Bool

    @Binding var statusConnect: VPNStatus
    @State var showAutoConnectDestinationSelection: Bool = false
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
                    currentTitle: "",
                    tapLeftButton: {
                        presentationMode.wrappedValue.dismiss()
                        showAutoConnectView = false
                    }, tapRightButton: {
                        UINavigationBar.setAnimationsEnabled(false)
                        showAutoConnectView = false
                        showSettings = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            UINavigationBar.setAnimationsEnabled(true)
                        }
                    }, statusConnect: $statusConnect)
                VStack(alignment: .leading, spacing: 1) {
                    ForEach(viewModel.sectionList, id: \.id) { section in
                        if section.type.title != "" {
                            Text(section.type.title)
                                .padding(.vertical)
                                .foregroundColor(AppColor.lightBlackText)
                                .font(Font.system(size: Constant.TextSize.Global.description))
                        }
                        ForEach(section.items, id: \.id) { item in
                            ItemRowCell(title: item.type.title,
                                        content: item.type.content,
                                        showRightButton: item.type.showRightButton,
                                        showSwitch: item.type.showSwitch,
                                        showSelect: item.type.showSelect,
                                        position: section.items.getPosition(item),
                                        item: item,
                                        switchValue: item.select,
                                        onSwitchValueChange: { value in
                                            if value {
                                                viewModel.configItem(item)
                                            }
                                        })
                                        .environmentObject(viewModel)
                                        .onTapGesture {
                                            switch item.type {
                                            case .fastestServer:
                                                showAutoConnectDestinationSelection = true
                                            default:
                                                return
                                            }
                                        }
                        }
                    }
                }
                .padding(Constant.Menu.hozitalPaddingCell)
                .padding(.top, Constant.Menu.topPaddingCell)
                .sheet(isPresented: $showAutoConnectDestinationSelection) {
                    AutoConnectDestinationSelectView(showSettings: $showSettings,
                                                     showVPNSetting: $showVPNSetting,
                                                     showAutoConnectView: $showAutoConnectView,
                                                     statusConnect: $statusConnect,
                                                     showAutoConnectDestinationSelection: $showAutoConnectDestinationSelection,
                                                     viewModel: AutoConnectDestinationSelectViewModel())
                        .onWillDisappear {
                            viewModel.configItem()
                        }
                }
            }
        }
        .navigationBarHidden(true)
        .background(AppColor.background)
        .ignoresSafeArea()
    }
}
