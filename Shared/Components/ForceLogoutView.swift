//
//  CenterViewPopup.swift
//  SysVPN
//
//  Created by Da Phan Van on 12/09/2022.
//

import Foundation
import SwiftUI

struct ForceLogoutView: View {
    
    var titleStr = L10n.Account.Session.Expired.title
    var messageStr = L10n.Account.Session.Expired.message
    var confirmStr = L10n.Account.Session.Expired.button
    
    var warning = false
    
    var confim: (() -> Void)? = nil
    
    var title: some View {
        HStack {
            Text(titleStr)
                .font(.system(size: Constant.TextSize.Global.titleMedium, weight: .bold))
                .foregroundColor(Color.white)
            Spacer()
        }
    }
    
    var message: some View {
        Text(messageStr)
            .font(.system(size: Constant.TextSize.Global.detailDefault, weight: .regular))
            .foregroundColor(Color.white)
    }
    
    var content: some View {
        VStack(alignment: .leading, spacing: 30) {
            title
            message
            AppButton(width: .infinity, backgroundColor: Color.white, textColor: AppColor.blackText , text: confirmStr) {
                if confim != nil {
                    confim?()
                }
            }
        }
        .padding(20)
        .frame(width: UIScreen.main.bounds.width - 44)
        .background(AppColor.grayBackground)
        .cornerRadius(radius: 15, corners: .allCorners)
    }
    
    var body: some View {
        ZStack {
            Asset.Assets.launchScreenBackGround.swiftUIImage
                .resizable()
                .aspectRatio(contentMode: .fill)
            VStack {
                Spacer()
                content
                Spacer()
            }
        }
    }
}
