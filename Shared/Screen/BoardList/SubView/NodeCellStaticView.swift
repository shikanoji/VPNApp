//
//  NodeCellStaticView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 09/02/2022.
//

import SwiftUI

struct NodeCellStaticView: View {
    @State var node: StaticServer
    
    let imageSize: CGFloat = Constant.BoardList.heightImageNode
    
    var body: some View {
        HStack(spacing: 16) {
            ImageView(withURL: $node.flag.wrappedValue, size: imageSize)
                .clipShape(Circle())
            Constant.StaticIP.iconS
                .frame(width: 20, height: 20)
            VStack(alignment: .leading, spacing: 6) {
                Text(node.getTitleContentCell())
                    .font(Constant.BoardList.fontNameCity)
                    .foregroundColor(.white)
                Text(node.getSubContentCell())
                    .font(Constant.BoardList.numberCities)
                    .foregroundColor(AppColor.lightBlackText)
            }
            Spacer()
            LinearGradientStatus(percent: node.currentLoad / 100)
        }
        .padding([.top, .bottom, .trailing])
        .frame(height: Constant.BoardList.heightStatusLoction)
    }
}

struct NodeCellStaticView_Previews: PreviewProvider {
    static var previews: some View {
        NodeCellStaticView(node: StaticServer())
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/365.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/))
    }
}
