//
//  DeviceCell.swift
//  SysVPN
//
//  Created by Da Phan Van on 18/01/2022.
//

import SwiftUI

struct SessionVPNCell: View {
    
    var sessionVPN: SessionVPN
        
    var position: PositionItemCell = .middle
    
    var removeDevice: (() -> Void)?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(sessionVPN.deviceBrand)
                        .font(Constant.Menu.fontItem)
                        .foregroundColor(.white)
                    if sessionVPN.isActive == 1 {
                        Circle()
                            .fill(AppColor.green)
                            .frame(width: 8, height: 8)
                    }
                }
                Text(sessionVPN.getSubContent())
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
        .padding(.bottom, 0)
        .frame(height: Constant.Menu.heightItemCell)
        .frame(maxWidth: .infinity)
        .background(AppColor.darkButton)
        .cornerRadius(radius: Constant.Menu.radiusCell, corners: [position.rectCorner])
    }
}
