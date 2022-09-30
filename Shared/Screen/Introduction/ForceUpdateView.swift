//
//  ForceUpdateView.swift
//  SysVPN
//
//  Created by Nguyen Dinh Thach on 08/08/2022.
//

import Foundation
import SwiftUI

struct ForceUpdateView: View {
    var content: some View {
        VStack {
            Asset.Assets.appIcon.swiftUIImage
            Spacer().frame(height: 20)
            Text(L10n.Introduction.updateRequired)
                .font(.system(size: Constant.TextSize.Global.titleLarge, weight: .bold))
                .foregroundColor(Color.white)
            Spacer().frame(height: 20)
            HStack {
                Spacer().frame(width: 30)
                Text(L10n.Introduction.updateRequiredNote)
                    .font(.system(size: Constant.TextSize.Global.detailDefault, weight: .regular))
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                Spacer().frame(width: 30)
            }
        }
    }
    var body: some View {
        Background {
            ZStack {
                Asset.Assets.greenLinearGradient.swiftUIImage.resizable()
                VStack(spacing: 20){
                    Spacer()
                    content
                    Spacer()
                    AppButton(style: .themeButton, width: UIScreen.main.bounds.size.width - 60, text: L10n.Introduction.updateNewVersion) {
                        if let url = URL(string: "https://apps.apple.com/app/id1630888108"),
                           UIApplication.shared.canOpenURL(url){
                            UIApplication.shared.open(url)
                        }
                    }
                    Spacer().frame(height:40)
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
        .navigationBarHidden(true)
    }
}
