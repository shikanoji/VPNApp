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
                .foregroundColor(AppColor.backgroundStatusView)
            HStack(spacing: 15) {
                ImageView(withURL: flag, size: 32, placeholder: UIImage(named: Constant.Board.Image.locationDefault))
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
                .foregroundColor(status.statusColor)
                .fontWeight(.semibold)
            Text(name == "" ? L10n.Board.subIP : ("Location: " + name))
        }
        .font(.system(size: Constant.Board.SubBoard.fontSize))
        .foregroundColor(Constant.Board.SubBoard.fontColor)
    }
}