//
//  ToolsView.swift
//  SysVPN (iOS)
//
//  Created by Nguyen Dinh Thach on 12/05/2022.
//

import Foundation
import SwiftUI

struct ToolsView: View {
    @Binding var showSettings: Bool
    @State var statusConnect: BoardViewModel.StateBoard = .connected
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var cyberSecItem: some View {
        ItemRowCell(title: L10n.Settings.Tools.cyberSec,
                    content: L10n.Settings.Tools.CyberSec.note,
                    showSwitch: true,
                    position: .all,
                    switchValue: true, onSwitchValueChange: { value in
            print("Cyber Sec = \(value)")
        })
    }
    
//    var killSwitchItem: some View {
//        ItemRowCell(title: L10n.Settings.Tools.killSwitch,
//                    content: L10n.Settings.Tools.KillSwitch.note,
//                    showSwitch: false,
//                    position: .middle)
//    }
//
//    var darkWebMonitorItem: some View {
//        ItemRowCell(title: L10n.Settings.Tools.darkWebMonitors,
//                    content: L10n.Settings.Tools.DarkWebMonitors.note,
//                    showSwitch: true,
//                    position: .middle, onSwitchValueChange: { value in
//            print("Dark Web Monitors = \(value)")
//        })
//    }
//
//    var tapJackingItem: some View {
//        ItemRowCell(title: L10n.Settings.Tools.tapJackingProtection,
//                    content: L10n.Settings.Tools.TapJackingProtection.note,
//                    showSwitch: true,
//                    position: .bot, onSwitchValueChange: { value in
//            print("Tap Jacking Protection = \(value)")
//        })
//    }
    
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
                    }, statusConnect: statusConnect)
                VStack(spacing: 1) {
                    cyberSecItem
//                    killSwitchItem
//                    darkWebMonitorItem
//                    tapJackingItem
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
