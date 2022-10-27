//
//  NodeCellView.swift
//  SysVPN
//
//  Created by Da Phan Van on 20/01/2022.
//

import SwiftUI

struct NodeCellView: View {
    @State var node: Node

    let imageSize: CGFloat = Constant.BoardList.heightImageNode

    var body: some View {
        HStack(spacing: 16) {
//            ImageView(withURL: $node.flag.wrappedValue, size: imageSize)
            Group {
                if let url = URL(string: node.flag) {
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
            .frame(width: imageSize,
                   height: imageSize)
            VStack(alignment: .leading, spacing: 4) {
                Text(node.name)
                    .font(Constant.BoardList.fontNameCity)
                    .foregroundColor(.white)
                Text(node.getNumberCity())
                    .font(Constant.BoardList.numberCities)
                    .foregroundColor(AppColor.lightBlackText)
            }
            Spacer()
            if !node.cityNodeList.isEmpty {
                Image(Constant.Account.rightButton)
                    .padding()
            }
        }
        .padding()
        .frame(height: Constant.BoardList.heightStatusLoction)
    }
}

struct NodeCellView_Previews: PreviewProvider {
    static var previews: some View {
        NodeCellView(node: Node.country)
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/365.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/))
    }
}
