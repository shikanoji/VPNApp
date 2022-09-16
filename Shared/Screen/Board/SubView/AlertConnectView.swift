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
//            Text(L10n.Board.connectedAlert)
//                .font(.system(size: Constant.Board.Alert.sizeFont, weight: Constant.Board.Alert.weightFont))
//                .lineLimit(1)
//                .padding(15)
//                .foregroundColor(.black)
//                .background(Color.white)
//                .cornerRadius(10)
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
            ImageView(withURL: flag, size: ensignSize)
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

//struct AlertConnectView_Previews: PreviewProvider {
//    static var previews: some View {
//        AlertConnectView()
//    }
//}
