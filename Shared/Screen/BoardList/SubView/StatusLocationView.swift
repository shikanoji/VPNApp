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
    
    @Binding var node: Node?
    @Binding var statusConnect: VPNStatus
    let imageSize: CGFloat = Constant.BoardList.heightImageNode / 2
    
    var body: some View {
        HStack(spacing: 0) {
            if let node = node, statusConnect == .connected {
                ImageView(withURL: node.flag, size: imageSize, placeholder: Constant.BoardList.iconCity)
                    .clipShape(Circle())
                    .padding()
                Text(node.name)
                    .font(Constant.BoardList.fontLocationStatus)
                    .foregroundColor(.white)
                NetworkWaveView(lineNumber: AppSetting.shared.lineNetwork)
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
