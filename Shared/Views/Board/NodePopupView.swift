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
                .frame(width: Constant.Board.NodePopupView.widthTriangle * scale,
                       height: Constant.Board.NodePopupView.heightTriangle * scale)
                .foregroundColor(Constant.Board.NodePopupView.backgroudTriangle)
        }
    }
    
    func getStateViewDescription() -> some View {
        if node.isCity {
            return AnyView(
                VStack(alignment: .center, spacing: 0) {
                    Text(node.name)
                        .font(.system(size: Constant.Board.NodePopupView.sizeFont * Constant.Board.Map.zoomCity * scale ,
                                      weight: Constant.Board.NodePopupView.weightFont))
                        .lineLimit(Constant.Board.NodePopupView.numberLineText)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.horizontal, Constant.Board.NodePopupView.paddingContent)
                        .background(AppColor.backgroundCity)
                        .minimumScaleFactor(.leastNonzeroMagnitude)
                    HStack(spacing: 6) {
                        Image(node.flag)
                            .resizable()
                            .frame(width: Constant.Board.NodePopupView.frameEnsign * Constant.Board.Map.zoomCity * scale,
                                   height: Constant.Board.NodePopupView.frameEnsign * Constant.Board.Map.zoomCity * scale)
                        Text(node.subRegion)
                            .font(.system(size: Constant.Board.NodePopupView.sizeFont * Constant.Board.Map.zoomCity * scale,
                                          weight: Constant.Board.NodePopupView.weightFont))
                            .lineLimit(Constant.Board.NodePopupView.numberLineText)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(Constant.Board.NodePopupView.paddingContent)
                }
                    .frame(height: Constant.Board.NodePopupView.heightContentPopupView * Constant.Board.Map.zoomCity * scale)
                    .fixedSize(horizontal: true, vertical: false)
            )
        } else {
            return AnyView(HStack {
                ImageView(withURL: node.flag, size: ensignSize * scale)
                    .clipShape(Circle())
                Text(node.name)
                    .font(.system(size: Constant.Board.NodePopupView.sizeFont * scale,
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
