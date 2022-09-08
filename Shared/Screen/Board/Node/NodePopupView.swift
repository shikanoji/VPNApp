//
//  NodePopupView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 05/01/2022.
//

import SwiftUI

struct NodePopupView: View {
    var node: Node!
    @Binding var scale: CGFloat
    
    let ensignSize: CGFloat = Constant.Board.NodePopupView.frameEnsign
    
    var body: some View {
        VStack(spacing: 0) {
            getStateViewDescription()
                .foregroundColor(.black)
                .background(Constant.Board.NodePopupView.backgroudTriangle)
                .cornerRadius(Constant.Board.NodePopupView.cornerRadius)
            Triangle()
                .frame(width: Constant.Board.NodePopupView.widthTriangle + 4,
                       height: Constant.Board.NodePopupView.heightTriangle + 2)
                .foregroundColor(Constant.Board.NodePopupView.backgroudTriangle)
                .padding(.top, -2)
        }
    }
    
    func getStateViewDescription() -> some View {
        if node.isCity {
            return AnyView(
                VStack(alignment: .center, spacing: 0) {
                    VStack{
                        Text(node.countryName)
                            .font(.system(size: Constant.Board.NodePopupView.sizeFont,
                                          weight: Constant.Board.NodePopupView.weightFont))
                            .lineLimit(Constant.Board.NodePopupView.numberLineText)
                            .frame(minWidth: 100, maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.vertical, Constant.Board.NodePopupView.paddingContent)
                            .minimumScaleFactor(.leastNonzeroMagnitude)
                            
                    }
                    .padding(8)
                    .background(AppColor.backgroundCity)
                    HStack(spacing: 6) {
                        ImageView(withURL: node.flag, size: ensignSize)
                            .clipShape(Circle())
                            .frame(width: Constant.Board.NodePopupView.frameEnsign,
                                   height: Constant.Board.NodePopupView.frameEnsign)
                        Text(node.name)
                            .font(.system(size: Constant.Board.NodePopupView.sizeFont,
                                          weight: Constant.Board.NodePopupView.weightFont))
                            .lineLimit(Constant.Board.NodePopupView.numberLineText)
                    }
                    .frame(minWidth: 100, maxWidth: .infinity, maxHeight: .infinity)
                    .padding(8)
                    .minimumScaleFactor(.leastNonzeroMagnitude)
                }
                    .fixedSize(horizontal: true, vertical: true)
            )
        } else {
            return AnyView(
                HStack(spacing: 10) {
                    ImageView(withURL: node.flag, size: ensignSize)
                        .clipShape(Circle())
                        .frame(width: Constant.Board.NodePopupView.frameEnsign,
                               height: Constant.Board.NodePopupView.frameEnsign)
                    Text(node.name)
                        .font(.system(size: Constant.Board.NodePopupView.sizeFont + 2,
                                      weight: Constant.Board.NodePopupView.weightFont))
                        .lineLimit(Constant.Board.NodePopupView.numberLineText)
                }
                    .padding(8)
                    .padding(.leading, 3)
            )
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
