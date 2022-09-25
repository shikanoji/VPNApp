//
//  MultiHopView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 08/02/2022.
//

import SwiftUI

struct MultiHopView: View {
    
    let sizeIcon = Constant.MultiHop.sizeIcon
    
    @Binding var mutilhopList: [MultihopModel]
    @Binding var multihopSelect: MultihopModel?
    
    @State var showDescriptionMultihop = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Button {
                    showDescriptionMultihop = true
                } label: {
                    HStack {
                        Constant.MultiHop.iconWhat
                        Text(L10n.Board.BoardList.MultiHop.what)
                            .foregroundColor(.white)
                            .font(Constant.BoardList.fontNodeList)
                    }
                }
                Spacer()
            }
            Spacer()
                .frame(height: 4)
            recentConnectionsView
            Spacer()
        }
        .padding()
        .frame(maxHeight: .infinity)
        .navigationBarHidden(true)
        .background(AppColor.background)
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $showDescriptionMultihop) {
            
        } content: {
            DescriptionMultihopView()
                .clearModalBackground()
        }
    }
    
    var recentConnectionsView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(L10n.Board.BoardList.MultiHop.recentConnections)
                .foregroundColor(AppColor.lightBlackText)
                .font(Constant.BoardList.fontNodeList)
            Spacer()
                .frame(height: 10)
            VStack {
                ForEach(mutilhopList) { item in
                    if let nodeEntry = item.entry?.country,
                       let nodeExit = item.exit?.country {
                        Button {
                            AppSetting.shared.temporaryDisableAutoConnect = false
                            if ItemCell(type: AppSetting.shared.getAutoConnectProtocol()).type == .off {
                                multihopSelect = item
                            }
                            NotificationCenter.default.post(name: Constant.NameNotification.showMap, object: nil)
                        } label: {
                            HStack {
                                ImageView(withURL: nodeEntry.flag, size: sizeIcon - 8)
                                    .clipShape(Circle())
                                    .brightness(-0.5)
                                    .padding(.trailing, -5)
                                ImageView(withURL: nodeExit.flag, size: sizeIcon)
                                    .clipShape(Circle())
                                Text(nodeEntry.name)
                                    .foregroundColor(.gray)
                                    .font(Constant.BoardList.fontNodeList)
                                Image(Constant.Account.rightButton)
                                Text(nodeExit.name)
                                    .foregroundColor(.white)
                                    .font(Constant.BoardList.fontNameCity)
                                Spacer()
                            }
                            .padding(.vertical, 5)
                        }
                    }
                }
            }
        }
    }
}
