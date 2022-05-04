//
//  DevicesView.swift
//  SysVPN
//
//  Created by Da Phan Van on 18/01/2022.
//

import SwiftUI

struct DevicesView: View {
    @Binding var showAccount: Bool
    @State var toogle: Bool = false
    @State var statusConnect: BoardViewModel.StateBoard = .connected
    @StateObject var viewModel: DeviceViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack(alignment: .top) {
                VStack {
                    AppColor.darkButton
                        .frame(height: 10)
                    CustomNavigationView(
                        leftTitle: L10n.Account.AccountStatus.title,
                        currentTitle: L10n.Account.itemDevices + " (\(AppSetting.shared.currentNumberDevice)/\(AppSetting.shared.totalNumberDevices))",
                        tapLeftButton: {
                            presentationMode.wrappedValue.dismiss()
                        }, tapRightButton: {
                            showAccount = false
                        }, statusConnect: statusConnect)
                    VStack(spacing: 1) {
//                        ForEach(Array(viewModel.deviceList.enumerated()), id: \.offset) { index, item in
//                            DeviceCell(deviceOnline: item,
//                                       position: viewModel.deviceList.getPosition(index)) {
//                                viewModel.deviceList.remove(at: index)
//                            }
//                        }
                        ForEach(viewModel.deviceList) { item in
                            DeviceCell(deviceOnline: item, position: viewModel.getDeviceCellPosition(device: item)) {
                                viewModel.remove(device: item)
                            }
                        }
                    }
                    .padding(Constant.Menu.hozitalPaddingCell)
                    .padding(.top, Constant.Menu.topPaddingCell)
                }
            }
        }
        .navigationBarHidden(true)
        .background(AppColor.background)
        .ignoresSafeArea()
    }
}

struct DevicesView_Previews: PreviewProvider {
    @State static var showAccount = true
    
    static var previews: some View {
        DevicesView(showAccount: $showAccount, viewModel: DeviceViewModel())
    }
}
