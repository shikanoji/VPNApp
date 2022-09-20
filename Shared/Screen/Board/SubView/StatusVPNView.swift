//
//  StatusVPNView.swift
//  SysVPN (iOS)
//
//  Created by Phan Văn Đa on 19/12/2021.
//

import SwiftUI
import TunnelKitManager

struct StatusVPNView: View {
    var ip: String
    var status: VPNStatus
    var flag: String
    var name: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: Constant.Board.SubBoard.radius)
                .foregroundColor(status == .connected ? AppColor.connectedStateView : AppColor.disconectStateView)
            HStack(spacing: 15) {
                if flag != "" && status == .connected {
                    ImageView(withURL: flag, size: 32, placeholder: UIImage(named: Constant.Board.Image.locationDefault))
                        .overlay(RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white, lineWidth: 2))
                } else {
                    Asset.Assets.iconLocationDefaultBoard.swiftUIImage
                }
                getStatusTextView()
            }
            .padding()
        }
        .frame(height: Constant.Board.SubBoard.height)
    }
    
    func getStatusTextView() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(L10n.Board.ip + " \(ip) - ")
            + Text(status.statusTitle)
                .foregroundColor(status == .connected ? AppColor.VPNConnected : .white)
                .fontWeight(.semibold)
            Text(name == "" ? L10n.Board.subIP : ("Location: " + name))
        }
        .font(.system(size: Constant.Board.SubBoard.fontSize))
        .foregroundColor(Constant.Board.SubBoard.fontColor)
    }
}
