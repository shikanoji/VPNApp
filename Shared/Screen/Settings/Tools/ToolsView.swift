//
//  ToolsView.swift
//  SysVPN (iOS)
//
//  Created by Nguyen Dinh Thach on 12/05/2022.
//

import Foundation
import SwiftUI
import TunnelKitManager

struct ToolsView: View {
    @Binding var showSettings: Bool
    @Binding var statusConnect: VPNStatus
    @StateObject var viewModel: ToolsViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                AppColor.darkButton
                    .frame(height: 10)
                CustomNavigationView(
                    leftTitle: L10n.Settings.title,
                    currentTitle: L10n.Settings.Tools.title,
                    tapLeftButton: {
                        presentationMode.wrappedValue.dismiss()
                    }, tapRightButton: {
                        showSettings = false
                        presentationMode.wrappedValue.dismiss()
                    }, statusConnect: $statusConnect)
                VStack(spacing: 1) {
                    ForEach(viewModel.section.items, id: \.id) { item in
                        ItemRowCell(title: item.type.title,
                                    content: item.type.content,
                                    showSwitch: item.type.showSwitch,
                                    position: viewModel.section.items.getPosition(item),
                                    switchValue: item.select,
                                    onSwitchValueChange: { value in
                            var changeItem = item
                            changeItem.select = value
                            viewModel.configItem(changeItem)
                        })
                        .environmentObject(viewModel)
                    }
                }
                .padding(Constant.Menu.hozitalPaddingCell)
                .padding(.top, Constant.Menu.topPaddingCell)
                Spacer().frame(height: 20)
            }
        }
        .navigationBarHidden(true)
        .background(AppColor.background)
        .ignoresSafeArea()
    }
}
