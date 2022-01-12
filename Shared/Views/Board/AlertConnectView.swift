//
//  AlertConnectView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 24/12/2021.
//

import SwiftUI

struct AlertConnectView: View {
    var body: some View {
        VStack(spacing: 0) {
            Text(LocalizedStringKey.Board.connectedAlert.localized)
                .font(.system(size: Constant.Board.Alert.sizeFont, weight: Constant.Board.Alert.weightFont))
                .lineLimit(1)
                .padding(5)
                .foregroundColor(.black)
                .background(AppColor.VPNConnected)
                .cornerRadius(10)
            Triangle()
                .frame(width: 15, height: 7.5)
                .foregroundColor(AppColor.VPNConnected)
        }
    }
}

struct Triangle : Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let width: CGFloat = rect.width
            let height: CGFloat = rect.height
            let cornerRadius = height / 3
            path.move(to: CGPoint(x: width, y: 0))
            path.addArc(center: CGPoint(x: width / 2, y: height - cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 45), endAngle: Angle(degrees: 135), clockwise: false)
            path.addLine(to: CGPoint(x: 0, y: 0))
        }
    }
}

struct AlertConnectView_Previews: PreviewProvider {
    static var previews: some View {
        AlertConnectView()
    }
}
