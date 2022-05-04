//
//  StaticNodePopupView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 04/05/2022.
//

import Foundation
import SwiftUI

struct StaticNodePopupView: View {
    @State var node: StaticServer!
    @Binding var scale: CGFloat
    
    let ensignSize: CGFloat = Constant.Board.NodePopupView.frameEnsign
    
    var body: some View {
        VStack(spacing: -1) {
            getStateViewDescription()
                .foregroundColor(.black)
                .background(Constant.Board.NodePopupView.backgroudTriangle)
                .cornerRadius(Constant.Board.NodePopupView.cornerRadius)
            Triangle()
                .frame(width: Constant.Board.NodePopupView.widthTriangle * scale * Constant.Board.Map.zoomCity,
                       height: Constant.Board.NodePopupView.heightTriangle * scale * Constant.Board.Map.zoomCity)
                .foregroundColor(Constant.Board.NodePopupView.backgroudTriangle)
        }
    }
    
    func getStateViewDescription() -> some View {
        VStack(alignment: .center, spacing: 0) {
            Text(node.countryName)
                .font(.system(size: Constant.Board.NodePopupView.sizeFont * Constant.Board.Map.zoomCity * scale ,
                              weight: Constant.Board.NodePopupView.weightFont))
                .lineLimit(Constant.Board.NodePopupView.numberLineText)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, Constant.Board.NodePopupView.paddingContent)
                .background(AppColor.backgroundCity)
                .minimumScaleFactor(.leastNonzeroMagnitude)
            HStack(spacing: 6) {
                
                ImageView(withURL: node.flag, size: ensignSize * Constant.Board.Map.zoomCity * scale)
                    .clipShape(Circle())
                    .frame(width: Constant.Board.NodePopupView.frameEnsign * Constant.Board.Map.zoomCity * scale,
                           height: Constant.Board.NodePopupView.frameEnsign * Constant.Board.Map.zoomCity * scale)
                Text(node.cityName)
                    .font(.system(size: Constant.Board.NodePopupView.sizeFont * Constant.Board.Map.zoomCity * scale,
                                  weight: Constant.Board.NodePopupView.weightFont))
                    .lineLimit(Constant.Board.NodePopupView.numberLineText)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.vertical, Constant.Board.NodePopupView.paddingContent)
            .padding(.horizontal, Constant.Board.NodePopupView.paddingContent * 2)
        }
        .frame(height: Constant.Board.NodePopupView.heightContentPopupView * Constant.Board.Map.zoomCity * scale)
        .fixedSize(horizontal: true, vertical: false)
    }
}
