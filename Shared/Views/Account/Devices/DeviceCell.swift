//
//  DeviceCell.swift
//  SysVPN
//
//  Created by Da Phan Van on 18/01/2022.
//

import SwiftUI

struct DeviceCell: View {
    
    @State var deviceOnline: DeviceOnline
    
    @State var position: PositionItemCell = .middle
    
    var removeDevice: (() -> Void)?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(deviceOnline.name)
                        .font(Constant.Menu.fontItem)
                        .foregroundColor(.white)
                    if deviceOnline.active {
                        Circle()
                            .fill(AppColor.green)
                            .frame(width: 8, height: 8)
                    }
                }
                Text(deviceOnline.ip + " - " + deviceOnline.location)
                    .font(Constant.Menu.fontSubItem)
                    .foregroundColor(AppColor.lightBlackText)
            }
            .padding(.leading, 16.0)
            Spacer()
            Image(Constant.Account.iconRemove)
                .padding()
                .onTapGesture {
                    removeDevice?()
                }
        }
        .frame(height: Constant.Menu.heightItemCell)
        .frame(maxWidth: .infinity)
        .background(AppColor.darkButton)
        .cornerRadius(radius: Constant.Menu.radiusCell, corners: [position.rectCorner])
    }
}

struct DeviceCell_Previews: PreviewProvider {
    static var previews: some View {
        DeviceCell(deviceOnline: DeviceOnline.example1()).previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/343.0/*@END_MENU_TOKEN@*/, height: Constant.Menu.heightItemCell + 40))
    }
}
