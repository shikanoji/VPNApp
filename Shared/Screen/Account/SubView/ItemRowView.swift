//
//  SettingItemView.swift
//  SysVPN
//
//  Created by Da Phan Van on 14/01/2022.
//

import SwiftUI

struct ItemRowView: View {
    @State var item: ItemCell
    @State var subTitle = ""
    @State var subContent = ""
    
    var body: some View {
        HStack(spacing: 0) {
            Image(item.type.iconString)
                .frame(width: Constant.Menu.sizeIconItemMenu,
                       height: Constant.Menu.sizeIconItemMenu)
                .padding([.top, .bottom, .trailing])
            VStack(alignment: .leading, spacing: 8) {
                Text(item.type.title + subTitle)
                    .font(Constant.Menu.fontItem)
                if subContent != "" || item.type.content != "" {
                    Text(subContent != "" ? subContent : item.type.content)
                        .font(Constant.Menu.fontSubItem)
                }
            }
            .frame(height: Constant.Menu.heightItemMenu)
            .foregroundColor(Color.white)
            Spacer()
            Image(Constant.Account.rightButton)
            .padding()
        }
        .frame(minHeight: Constant.Menu.heightItemMenu)
        .frame(maxWidth: .infinity)
        .background(Color.clear)
    }
}

struct SettingItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowView(item: ItemCell(type: .totalDevice), subContent: "Exprire on 2023-10-27")
            .frame(width: 365.0, height: Constant.Menu.heightItemMenu)
            .previewLayout(.sizeThatFits)
            .background(AppColor.background)
    }
}
