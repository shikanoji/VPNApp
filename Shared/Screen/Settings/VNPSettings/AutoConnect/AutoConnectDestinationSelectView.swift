//
//  AutoConnectDestinationSelectView.swift
//  SysVPN (iOS)
//
//  Created by Nguyen Dinh Thach on 29/06/2022.
//

import Foundation
import SwiftUI
import TunnelKitManager

struct BlurView: UIViewRepresentable {

    let style: UIBlurEffect.Style

    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        return view
    }

    func updateUIView(_ uiView: UIView,
                      context: UIViewRepresentableContext<BlurView>) {

    }
}

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
            ScrollView(showsIndicators: false) {
                VStack {
                    HStack {
                        Button {
                            showAutoConnectDestinationSelection = false
                        } label: {
                            Asset.Assets.close.swiftUIImage
                        }
                        Spacer()
                    }
                    .frame(height: 50)
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
        .background(AppColor.background)
        .ignoresSafeArea()
        .onAppear(perform: {
            viewModel.getCountryList()
        })
    }
}
