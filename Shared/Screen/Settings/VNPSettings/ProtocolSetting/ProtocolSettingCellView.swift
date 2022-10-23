//
//  ProtocolSettingCellView.swift
//  SysVPN
//
//  Created by Da Phan Van on 29/04/2022.
//

import SwiftUI

struct ProtocolSettingCellView: View {
    
    @State var title: String
    @State var position: PositionItemCell = .middle
    @State var changeValue = false
    
    @EnvironmentObject var viewModel: ProtocolSettingViewModel
    
    var item: ItemCell
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(Constant.Menu.fontItem)
            }
            .padding(.leading, 16.0)
            Spacer()
            Toggle(isOn: Binding<Bool>(
                get: { item.select },
                set: {
                    var newItem = item
                    newItem.select = $0
                    viewModel.updateItem(newItem)
                }
            )) { }
                .toggleStyle(SelectToggleStyle())
                .padding(.trailing, 15.0)
        }
        .padding(.vertical, 8.0)
        .frame(minHeight: Constant.Menu.heightItemMenu)
        .frame(maxWidth: .infinity)
        .background(AppColor.darkButton)
        .cornerRadius(radius: Constant.Menu.radiusCell, corners: [position.rectCorner])
    }
}

struct ProtocolSettingCellView_Previews: PreviewProvider {
    static var previews: some View {
        ProtocolSettingCellView(title: "Your email", item: ItemCell(type: .openVPN))
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/343.0/*@END_MENU_TOKEN@*/, height: Constant.Menu.heightItemCell + 200))
    }
}
