//
//  SpeedConnectedView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 27/12/2021.
//

import SwiftUI

struct SpeedConnectedView: View {
    
    var uploadSpeed: CGFloat
    var downLoadSpeed: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 5) {
                Image(Constant.Board.Image.uploadSpeed)
                    .resizable()
                    .frame(width: Constant.Board.Speed.heightIcon, height: Constant.Board.Speed.heightIcon)
                Text("\(Int(uploadSpeed))\(L10n.Board.speed)")
                    .lineLimit(1)
                    .foregroundColor(.white)
            }
            HStack(spacing: 5) {
                Image(Constant.Board.Image.downloadSpeed)
                    .resizable()
                    .frame(width: Constant.Board.Speed.heightIcon, height: Constant.Board.Speed.heightIcon)
                Text("\(Int(downLoadSpeed))\(L10n.Board.speed)")
                    .lineLimit(1)
                    .foregroundColor(.white)
            }
        }
    }
}

struct SpeedConnectedView_Previews: PreviewProvider {
    static var previews: some View {
        SpeedConnectedView(uploadSpeed: 100, downLoadSpeed: 100)
            .preferredColorScheme(.dark)
    }
}
