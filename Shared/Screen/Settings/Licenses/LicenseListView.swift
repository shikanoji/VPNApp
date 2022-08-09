//
//  LicenseListView.swift
//  SysVPN
//
//  Created by Nguyen Dinh Thach on 21/07/2022.
//

import Foundation
import SwiftUI
import TunnelKitManager

struct LicenseListView: View {
    @Binding var showSettings: Bool
    @Binding var statusConnect: VPNStatus
    @StateObject var viewModel: LicenseListViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack {
            AppColor.darkButton
                .frame(height: 20)
            CustomNavigationView(
                leftTitle: L10n.Settings.title,
                currentTitle: L10n.Settings.licenses,
                tapLeftButton: {
                    presentationMode.wrappedValue.dismiss()
                }, tapRightButton: {
                    showSettings = false
                    presentationMode.wrappedValue.dismiss()
                }, statusConnect: $statusConnect)
            .padding(.bottom, Constant.Menu.topPaddingCell)
            
            ScrollView(.vertical, showsIndicators: false) {
                ZStack(alignment: .top) {
                    VStack(spacing: 1) {
                        Spacer().frame(height: 15)
                        ForEach(viewModel.licenseTitleList.indices, id: \.self) { i in
                            NavigationLink {
                                LicenseDetailView(viewModel: LicenseDetailViewModel(license: viewModel.licenseTitleList[i]))
                                    .navigationBarHidden(false)
                            } label: {
                                ItemRowCell(title: viewModel.licenseTitleList[i].title ?? "",
                                            showRightButton: true,
                                            position: viewModel.licenseTitleList.getPosition(i))
                            }
                            
                        }
                        .padding(.horizontal, Constant.Menu.hozitalPaddingCell)
                        Spacer().frame(height: 20)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .background(AppColor.background)
        .ignoresSafeArea()
        .onAppear(perform: {
            viewModel.loadLicenses()
        })
    }
}