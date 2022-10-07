//
//  AutoConnectDestinationSelectView.swift
//  SysVPN (iOS)
//
//  Created by Nguyen Dinh Thach on 29/06/2022.
//

import Foundation
import SwiftUI
import TunnelKitManager

struct AutoConnectDestinationSelectView: View {
    @Binding var showSettings: Bool
    @Binding var showVPNSetting: Bool
    @Binding var shouldHideAutoConnect: Bool
    @Binding var statusConnect: VPNStatus
    @Binding var showAutoConnectDestinationSelection: Bool
    @StateObject var viewModel: AutoConnectDestinationSelectViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            VStack {
                LedgeTopView()
                    .padding(.top, 10)
                LocationListView(locationData: $viewModel.locationData,
                                 nodeSelect: $viewModel.node,
                                 hasFastestOption: true)
                .padding(.top)
                .onChange(of: viewModel.shouldAutoCloseView){ shouldCloseView in
                    if shouldCloseView {
                        showAutoConnectDestinationSelection = false
                    }
                }
            }
            .background(AppColor.background)
            .ignoresSafeArea()
            .onAppear(perform: {
                if !AppSetting.shared.isConnectedToVpn {
                    viewModel.getCountryList()
                } else {
                    viewModel.getDataFromLocal()
                }
            })
        }
    }
}
