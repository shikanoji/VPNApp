//
//  AlertConnectView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 24/12/2021.
//

import SwiftUI

struct AlertConnectView: View {
    var flag: String
    var name: String
    let ensignSize: CGFloat = Constant.Board.NodePopupView.frameEnsign

    var body: some View {
        VStack(spacing: 0) {
            AlertConnectView()
                .foregroundColor(.black)
                .background(Constant.Board.NodePopupView.backgroudTriangle)
                .cornerRadius(Constant.Board.NodePopupView.cornerRadius)
            Triangle()
                .frame(width: 15, height: 7.5)
                .foregroundColor(.white)
        }
    }

    func AlertConnectView() -> some View {
        HStack(spacing: 10) {
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
            .frame(width: Constant.Board.NodePopupView.frameEnsign,
                   height: Constant.Board.NodePopupView.frameEnsign)
            Text(name)
                .font(.system(size: Constant.Board.NodePopupView.sizeFont + 2,
                              weight: Constant.Board.NodePopupView.weightFont))
                .lineLimit(Constant.Board.NodePopupView.numberLineText)
        }
        .padding(8)
    }
}

struct Triangle : Shape {
    var soft = true

    func path(in rect: CGRect) -> Path {
        Path { path in
            let width: CGFloat = rect.width
            let height: CGFloat = rect.height
            let cornerRadius = height / 3
            path.move(to: CGPoint(x: width, y: 0))
            if soft {
                path.addArc(center: CGPoint(x: width / 2, y: height - cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 45), endAngle: Angle(degrees: 135), clockwise: false)
            } else {
                path.addLine(to: CGPoint(x: width / 2, y: height - cornerRadius))
            }
            path.addLine(to: CGPoint(x: 0, y: 0))
        }
    }
}
