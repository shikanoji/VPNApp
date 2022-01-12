//
//  NodePopupView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 05/01/2022.
//

import SwiftUI

struct NodePopupView: View {
    @State var node: Node!
    
    var body: some View {
        VStack(spacing: -1) {
            getStateViewDescription()
                .foregroundColor(.black)
                .background(Constant.Board.NodePopupView.backgroudTriangle)
                .cornerRadius(Constant.Board.NodePopupView.cornerRadius)
            Triangle()
                .frame(width: Constant.Board.NodePopupView.widthTriangle, height: Constant.Board.NodePopupView.heightTriangle)
                .foregroundColor(Constant.Board.NodePopupView.backgroudTriangle)
        }
    }
    
    func getStateViewDescription() -> some View {
        if node.isCity {
            return AnyView(
                VStack(alignment: .center, spacing: 0) {
                    Text(node.subName)
                        .font(.system(size: Constant.Board.NodePopupView.sizeFont * Constant.Board.Map.zoomCity,
                                      weight: Constant.Board.NodePopupView.weightFont))
                        .lineLimit(Constant.Board.NodePopupView.numberLineText)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.horizontal, Constant.Board.NodePopupView.paddingContent)
                        .background(AppColor.backgroundCity)
                        .minimumScaleFactor(.leastNonzeroMagnitude)
                    HStack(spacing: 6) {
                        Image(node.ensign)
                            .resizable()
                            .frame(width: Constant.Board.NodePopupView.frameEnsign * Constant.Board.Map.zoomCity,
                                   height: Constant.Board.NodePopupView.frameEnsign * Constant.Board.Map.zoomCity)
                        Text(node.name)
                            .font(.system(size: Constant.Board.NodePopupView.sizeFont * Constant.Board.Map.zoomCity,
                                          weight: Constant.Board.NodePopupView.weightFont))
                            .lineLimit(Constant.Board.NodePopupView.numberLineText)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(Constant.Board.NodePopupView.paddingContent)
                }
                    .frame(height: Constant.Board.NodePopupView.heightContentPopupView * Constant.Board.Map.zoomCity)
                    .fixedSize(horizontal: true, vertical: false)
            )
        } else {
            return AnyView(HStack {
                Image(node.ensign)
                    .resizable()
                    .frame(width: Constant.Board.NodePopupView.frameEnsign,
                           height: Constant.Board.NodePopupView.frameEnsign)
                Text(node.name)
                    .font(.system(size: Constant.Board.NodePopupView.sizeFont,
                                  weight: Constant.Board.NodePopupView.weightFont))
                    .lineLimit(Constant.Board.NodePopupView.numberLineText)
            }.padding(5))
        }
    }
}


struct NodePopupView_Previews: PreviewProvider {
    static var previews: some View {
        NodePopupView(node: Node.simple0)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .frame(width: 300.0, height: 300.0)
    }
}
