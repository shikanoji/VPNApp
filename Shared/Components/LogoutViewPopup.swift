//
//  LogoutViewPopup.swift
//  SysVPN
//
//  Created by Da Phan Van on 06/09/2022.
//

import Foundation
import SwiftUI

struct LogoutViewPopup: View {
    
    var cancel: (() -> Void)?
    var confim: (() -> Void)?
    
    var title: some View {
        HStack {
            Text(L10n.Account.Logout.confirm)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color.white)
            Spacer()
        }
    }
    
    var message: some View {
        Text(L10n.Account.Logout.Confirm.message)
            .font(.system(size: 14, weight: .regular))
            .foregroundColor(AppColor.yellowGradient)
    }
    
    var content: some View {
        VStack(spacing: 30) {
            title
            message
            AppButton(width: .infinity, backgroundColor: AppColor.darkButton, textColor: Color.white , text: L10n.Account.signout) {
                confim?()
            }
        }
        .padding(20)
        .frame(width: UIScreen.main.bounds.width)
        .background(AppColor.background)
        .cornerRadius(radius: 15, corners: [.topLeft, .topRight])
    }
    
    var body: some View {
        ZStack {
            Background{}
                .opacity(0.9)
                .onTapGesture {
                    cancel?()
                }
            VStack {
                Spacer().frame(height: 40)
                HStack {
                    Button {
                        cancel?()
                    } label: {
                        Asset.Assets.close.swiftUIImage
                    }
                    Spacer()
                }
                Spacer()
                content
            }
        }
        .background(PopupBackgroundView())
        .ignoresSafeArea()
    }
}
