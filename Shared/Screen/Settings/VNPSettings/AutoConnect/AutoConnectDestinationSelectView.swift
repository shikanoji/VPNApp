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
        ZStack {
            Background{}.opacity(0.8)
            ScrollView(showsIndicators: false) {
                VStack {
                    Spacer().frame(height: 40)
                    HStack {
                        Button {
                            showAutoConnectDestinationSelection = false
                        } label: {
                            Asset.Assets.close.swiftUIImage
                        }
                        Spacer()
                    }
                    Spacer().frame(height: 40)
                    LocationListView(locationData: $viewModel.locationData,
                                     nodeSelect: $viewModel.node,
                                     hasFastestOption: true,
                                     showAutoConnectionDestinationView: $showAutoConnectDestinationSelection)
                }
                .onChange(of: viewModel.shouldAutoCloseView){ shouldCloseView in
                    if shouldCloseView {
                        showAutoConnectDestinationSelection = false
                    }
                }
            }
        }
        .background(PopupBackgroundView())
        .ignoresSafeArea()
        .onAppear(perform: {
            viewModel.getCountryList()
        })
    }
}
