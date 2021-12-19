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
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constant.Board.SubBoard.radius)
                .foregroundColor(.white)
            HStack {
                Image(Constant.Board.Image.unconnect)
                VStack(alignment: .leading) {
                    getStatusText()
                    Text("Connect to VPN to online sercurity")
                        .foregroundColor(.black)
                }
            }
        }
        .frame(height: Constant.Board.SubBoard.height)
    }
    
    init(ip: String, status: BoardViewModel.StateBoard) {
        self.ip = ip
        self.status = status
    }
    
    func getStatusText() -> Text {
        Text("Your IP: \(ip) - ")
            .foregroundColor(.black) + Text(status.subTitle)
            .foregroundColor(status.subColor)
    }
}

struct StatusVPNView_Previews: PreviewProvider {
    static var previews: some View {
        StatusVPNView(ip: "199.199.199.8", status: .start)
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/343.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/68.0/*@END_MENU_TOKEN@*/))
    }
}
