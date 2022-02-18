//
//  CityCellView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 08/02/2022.
//

import SwiftUI

struct CityCellView: View {
    @State var node: Node
    @State var subName = ""
    
    let imageSize: CGFloat = Constant.BoardList.heightImageNode
    
    var body: some View {
        HStack(spacing: 16) {
            Constant.BoardList.iconCity
                .frame(width: imageSize,
                       height: imageSize)
            VStack(alignment: .leading, spacing: 4) {
                Text(node.name)
                    .font(Constant.BoardList.fontNameCity)
                    .foregroundColor(.white)
                Text(subName)
                    .font(Constant.BoardList.numberCities)
                    .foregroundColor(AppColor.lightBlackText)
            }
            Spacer()
        }
        .padding()
        .frame(height: Constant.BoardList.heightStatusLoction)
    }
}

struct CityCellView_Previews: PreviewProvider {
    static var previews: some View {
        CityCellView(node: Node.country)
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/365.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/))
    }
}
