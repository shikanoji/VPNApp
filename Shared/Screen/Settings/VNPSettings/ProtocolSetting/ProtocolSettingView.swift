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
                        showVPNSetting = false
                        showSettings = false
                    }, statusConnect: $statusConnect)
                VStack(alignment: .leading, spacing: 1) {
                    ForEach(viewModel.itemList) { item in
                        ProtocolSettingCellView(title: item.type.title,
                                                position: getPosition(item: item, arr: viewModel.itemList),
                                                changeValue: item.select,
                                                item: item)
                        .environmentObject(viewModel)
                    }
                }
                .padding(Constant.Menu.hozitalPaddingCell)
                .padding(.top, Constant.Menu.topPaddingCell)
            }
        }
        .onAppear {
            viewModel.refreshItem()
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
