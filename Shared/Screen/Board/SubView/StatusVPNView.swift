//
//  StatusVPNView.swift
//  SysVPN (iOS)
//
//  Created by Phan Văn Đa on 19/12/2021.
//

import SwiftUI

struct StatusVPNView: View {
    var ip: String
    var status: BoardViewModel.StateBoard
    var flag: String
    
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
            Text(L10n.Board.subIP)
        }
        .font(.system(size: Constant.Board.SubBoard.fontSize))
        .foregroundColor(Constant.Board.SubBoard.fontColor)
    }
}

struct StatusVPNView_Previews: PreviewProvider {
    
    static var previews: some View {
        StatusVPNView(ip: "199.199.199.8", status: .notConnect, flag: "")
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/343.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/68.0/*@END_MENU_TOKEN@*/))
    }
}
