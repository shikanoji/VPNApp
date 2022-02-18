//
//  StatusLocationView.swift
//  SysVPN
//
//  Created by Da Phan Van on 19/01/2022.
//

import SwiftUI

struct StatusLocationView: View {
    
    @State var node: Node?
    
    var body: some View {
        HStack(spacing: 0) {
            if let node = node {
                Image(node.flag)
                    .resizable()
                    .frame(width: 16, height: 16)
                    .padding()
                Text(node.name)
                    .font(Constant.BoardList.fontLocationStatus)
                    .foregroundColor(.white)
                NetworkWaveView(lineNumber: AppSetting.shared.lineNetwork)
                    .padding()
            } else {
                Text(LocalizedStringKey.Board.backToMap.localized)
                    .foregroundColor(.white)
                    .font(Constant.BoardList.fontLocationStatus)
                    .padding()
            }
            Spacer()
            Image(Constant.BoardList.iconUp)
                .padding()
        }
        .frame(maxWidth: .infinity)
        .frame(height: Constant.BoardList.heightStatusLoction)
        .background(AppColor.background)
    }
}

struct StatusLocationView_Previews: PreviewProvider {
    static var previews: some View {
        StatusLocationView(node: nil)
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/375.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/60.0/*@END_MENU_TOKEN@*/))
    }
}
