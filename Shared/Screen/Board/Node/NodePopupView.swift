//
//  NodePopupView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 05/01/2022.
//

import SwiftUI

struct NodePopupView: View {
    @State var node: Node!
    @Binding var scale: CGFloat
    
    let ensignSize: CGFloat = Constant.Board.NodePopupView.frameEnsign
    
    var body: some View {
        VStack(spacing: -1) {
            getStateViewDescription()
                .foregroundColor(.black)
                .background(Constant.Board.NodePopupView.backgroudTriangle)
                .cornerRadius(Constant.Board.NodePopupView.cornerRadius)
            Triangle()
                .frame(width: Constant.Board.NodePopupView.widthTriangle,
                       height: Constant.Board.NodePopupView.heightTriangle)
                .foregroundColor(Constant.Board.NodePopupView.backgroudTriangle)
        }
    }
    
    func getStateViewDescription() -> some View {
        if node.isCity {
            return AnyView(
                VStack(alignment: .center, spacing: 0) {
                    Text(node.countryName)
                        .font(.system(size: Constant.Board.NodePopupView.sizeFont * Constant.Board.Map.zoomCity ,
                                      weight: Constant.Board.NodePopupView.weightFont))
                        .lineLimit(Constant.Board.NodePopupView.numberLineText)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.vertical, Constant.Board.NodePopupView.paddingContent)
                        .minimumScaleFactor(.leastNonzeroMagnitude)
                        .background(AppColor.backgroundCity)
                    HStack(spacing: 6) {
                        ImageView(withURL: node.flag, size: ensignSize * Constant.Board.Map.zoomCity)
                            .clipShape(Circle())
                            .frame(width: Constant.Board.NodePopupView.frameEnsign * Constant.Board.Map.zoomCity,
                                   height: Constant.Board.NodePopupView.frameEnsign * Constant.Board.Map.zoomCity)
                        Text(node.name)
                            .font(.system(size: Constant.Board.NodePopupView.sizeFont * Constant.Board.Map.zoomCity,
                                          weight: Constant.Board.NodePopupView.weightFont))
                            .lineLimit(Constant.Board.NodePopupView.numberLineText)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(Constant.Board.NodePopupView.paddingContent)
                    .minimumScaleFactor(.leastNonzeroMagnitude)
                }
                    .frame(height: Constant.Board.NodePopupView.heightContentPopupView)
                    .fixedSize(horizontal: true, vertical: true)
            )
        } else {
            return AnyView(HStack {
                ImageView(withURL: node.flag, size: ensignSize)
                    .clipShape(Circle())
                Text(node.name)
                    .font(.system(size: Constant.Board.NodePopupView.sizeFont,
                                  weight: Constant.Board.NodePopupView.weightFont))
                    .lineLimit(Constant.Board.NodePopupView.numberLineText)
            }.padding(10))
        }
    }
}


struct NodePopupView_Previews: PreviewProvider {
    @State static var scale: CGFloat = 1.0
    
    static var previews: some View {
        NodePopupView(node: Node.country, scale: $scale)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .frame(width: 300.0, height: 300.0)
    }
}