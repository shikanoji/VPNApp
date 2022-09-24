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
    var hasContent: Bool {
        subContent != "" || item.type.content != ""
    }
    var body: some View {
        VStack {
            Spacer().frame(height: 20)
            HStack(spacing: 0) {
                if item.type.icon != nil {
                    item.type.icon?
                        .resizable()
                        .frame(width: 38, height: 38)
                    Spacer().frame(width: 20)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(item.type.title + subTitle)
                        .font(Constant.Menu.fontItem)
                        .foregroundColor(Color.white)
                    if subContent != "" || item.type.content != "" {
                        Text(subContent != "" ? subContent : item.type.content)
                            .font(Constant.Menu.fontSubItem)
                            .foregroundColor(AppColor.lightBlackText)
                    }
                }
                Spacer()
                if item.type.showRightButton {
                    Image(Constant.Account.rightButton)
                    Spacer().frame(width: 10)
                }
            }
            .contentShape(Rectangle())
            .frame(maxWidth: .infinity)
            .background(Color.clear)
        }
    }
}

struct SettingItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowView(item: ItemCell(type: .totalDevice), subContent: "Exprire on 2023-10-27")
            .frame(width: 365.0)
            .previewLayout(.sizeThatFits)
            .background(AppColor.background)
    }
}
