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
    
    @State var showDescriptionMultihopIpad = false
    @State var showDescriptionMultihopIphone = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Button {
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        self.showDescriptionMultihopIpad = true
                    } else {
                        self.showDescriptionMultihopIphone = true
                    }
                    
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
        .sheet(isPresented: $showDescriptionMultihopIphone) {
            DescriptionMultihopView(cancel: {
                self.showDescriptionMultihopIphone = false
            })
            .clearModalBackground()
        }
        .fullScreenCover(isPresented: $showDescriptionMultihopIpad) {
            DescriptionMultihopView(cancel: {
                self.showDescriptionMultihopIpad = false
            })
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
                            multihopSelect = item
                        } label: {
                            HStack {
                                Group {
                                    if let url = URL(string: nodeEntry.flag) {
                                        AsyncImage(
                                            url: url,
                                            placeholder: {
                                                Asset.Assets.flagDefault.swiftUIImage
                                                    .resizable()
                                            },
                                            image: { Image(uiImage: $0).resizable() })
                                    } else {
                                        Asset.Assets.flagDefault.swiftUIImage
                                    }
                                }
                                .frame(width: sizeIcon - 6,
                                       height: sizeIcon - 6)
                                .clipShape(Circle())
                                .brightness(-0.5)
                                .padding(.trailing, -5)
                                Group {
                                    if let url = URL(string: nodeExit.flag) {
                                        AsyncImage(
                                            url: url,
                                            placeholder: {
                                                Asset.Assets.flagDefault.swiftUIImage
                                                    .resizable()
                                            },
                                            image: { Image(uiImage: $0).resizable() })
                                    } else {
                                        Asset.Assets.flagDefault.swiftUIImage
                                    }
                                }
                                .clipShape(Circle())
                                .frame(width: sizeIcon,
                                       height: sizeIcon)
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
