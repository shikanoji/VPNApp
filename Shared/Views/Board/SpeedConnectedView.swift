//
//  SpeedConnectedView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 27/12/2021.
//

import SwiftUI

struct SpeedConnectedView: View {
    
    @State private var uploadSpeed: CGFloat
    @State private var downLoadSpeed: CGFloat
    
    init(uploadSpeed: CGFloat = 0.0, downLoadSpeed: CGFloat = 0.0) {
        self.uploadSpeed = uploadSpeed
        self.downLoadSpeed = downLoadSpeed
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 5) {
                Image(Constant.Board.Image.uploadSpeed)
                    .resizable()
                    .frame(width: Constant.Board.Speed.heightIcon, height: Constant.Board.Speed.heightIcon)
                Text("\(Int(uploadSpeed))\(LocalizedStringKey.Board.speed.localized)")
                    .lineLimit(1)
                    .foregroundColor(.white)
            }
            HStack(spacing: 5) {
                Image(Constant.Board.Image.downloadSpeed)
                    .resizable()
                    .frame(width: Constant.Board.Speed.heightIcon, height: Constant.Board.Speed.heightIcon)
                Text("\(Int(downLoadSpeed))\(LocalizedStringKey.Board.speed.localized)")
                    .lineLimit(1)
                    .foregroundColor(.white)
            }
        }
    }
}

struct SpeedConnectedView_Previews: PreviewProvider {
    static var previews: some View {
        SpeedConnectedView(uploadSpeed: 1000, downLoadSpeed: 300)
            .preferredColorScheme(.dark)
    }
}
