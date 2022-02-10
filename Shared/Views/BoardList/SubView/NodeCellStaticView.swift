//
//  NodeCellStaticView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 09/02/2022.
//

import SwiftUI

struct NodeCellStaticView: View {
    @State var node: Node
    
    let imageSize: CGFloat = Constant.BoardList.heightImageNode
    
    var body: some View {
        HStack(spacing: 16) {
            ImageView(withURL: $node.flag.wrappedValue, size: imageSize)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Constant.StaticIP.iconS
                    Text(node.name)
                        .font(Constant.BoardList.fontNameCity)
                        .foregroundColor(.white)
                }
                Text(node.getNumberCity())
                    .font(Constant.BoardList.numberCities)
                    .foregroundColor(AppColor.lightBlackText)
            }
            Spacer()
            if node.cityNodeList.count > 0 {
                Image(Constant.Account.rightButton)
                    .padding()
            }
        }
        .padding()
        .frame(height: Constant.BoardList.heightStatusLoction)
    }
}

struct NodeCellStaticView_Previews: PreviewProvider {
    static var previews: some View {
        NodeCellStaticView(node: Node.country)
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/365.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/))
    }
}
