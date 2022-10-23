//
//  StatusLocationView.swift
//  SysVPN
//
//  Created by Da Phan Van on 19/01/2022.
//

import SwiftUI
import TunnelKitManager
import TunnelKitCore

struct StatusLocationView: View {
    @Binding var statusConnect: VPNStatus
    @Binding var flag: String
    @Binding var name: String
    
    let imageSize: CGFloat = Constant.BoardList.heightImageNode / 2
    
    var body: some View {
        HStack(spacing: 0) {
            if statusConnect == .connected {
                Group {
                    if let url = URL(string: flag) {
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
                .frame(width: imageSize + 4,
                       height: imageSize + 4)
                .padding()
                Text(name)
                    .font(Constant.BoardList.fontLocationStatus)
                    .foregroundColor(.white)
                NetworkWaveView()
                    .padding()
            } else {
                Text(L10n.Board.backToMap)
                    .foregroundColor(.white)
                    .font(Constant.BoardList.fontLocationStatus)
                    .padding()
            }
            Spacer()
            Image(Constant.BoardList.iconUp)
                .rotationEffect(.radians(.pi))
                .padding()
        }
        .frame(maxWidth: .infinity)
        .frame(height: Constant.BoardList.heightStatusLoction)
        .background(AppColor.background)
    }
}
