//
//  DevicesView.swift
//  SysVPN
//
//  Created by Da Phan Van on 18/01/2022.
//

import SwiftUI

struct DevicesView: View {
    @Binding var showAccount: Bool
    @State var statusConnect: BoardViewModel.StateBoard = .connected
    
    @State var deviceList = DeviceOnline.exampleList()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack(alignment: .top) {
                VStack {
                    AppColor.darkButton
                        .frame(height: 10)
                    CustomNavigationView(
                        leftTitle: LocalizedStringKey.AccountStatus.title.localized,
                        currentTitle: LocalizedStringKey.Account.itemDevices.localized + " (\(AppSetting.shared.currentNumberDevice)/\(AppSetting.shared.totalNumberDevices))",
                        tapLeftButton: {
                            presentationMode.wrappedValue.dismiss()
                        }, tapRightButton: {
                            showAccount = false
                        }, statusConnect: statusConnect)
                    VStack(spacing: 1) {
                        ForEach(deviceList.indices) { i in
                            DeviceCell(deviceOnline: deviceList[i],
                                       position: deviceList.getPosition(i)) {
                                deviceList.remove(at: i)
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
        DevicesView(showAccount: $showAccount)
    }
}
