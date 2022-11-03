//
//  SpeedConnectedView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 27/12/2021.
//

import SwiftUI

struct SpeedConnectedView: View {
    @EnvironmentObject var networkTraffic: NetworkTraffic

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 5) {
                Image(Constant.Board.Image.uploadSpeed)
                    .resizable()
                    .frame(width: Constant.Board.Speed.heightIcon, height: Constant.Board.Speed.heightIcon)
                Text(networkTraffic.uploadSpeed)
                    .lineLimit(1)
                    .foregroundColor(.white)
                    .font(.system(size: Constant.TextSize.Global.detailDefault, weight: .bold))
            }
            HStack(spacing: 5) {
                Image(Constant.Board.Image.downloadSpeed)
                    .resizable()
                    .frame(width: Constant.Board.Speed.heightIcon, height: Constant.Board.Speed.heightIcon)
                Text(networkTraffic.downloadSpeed)
                    .lineLimit(1)
                    .foregroundColor(.white)
                    .font(.system(size: Constant.TextSize.Global.detailDefault, weight: .bold))
            }
        }
    }
}
