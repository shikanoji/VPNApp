//
//  LogoutViewPopup.swift
//  SysVPN
//
//  Created by Da Phan Van on 06/09/2022.
//

import Foundation
import SwiftUI

struct BottomViewPopup: View {
    
    var titleStr = L10n.Account.Logout.confirm
    var messageStr = L10n.Account.Logout.Confirm.message
    var confirmStr = L10n.Account.signout
    
    var warning = false
    
    var cancel: (() -> Void)? = nil
    var confim: (() -> Void)? = nil
    
    var title: some View {
        HStack {
            Text(titleStr)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color.white)
            Spacer()
        }
    }
    
    var message: some View {
        Text(messageStr)
            .font(.system(size: 14, weight: .regular))
            .foregroundColor(AppColor.yellowGradient)
    }
    
    var content: some View {
        VStack(alignment: .leading, spacing: 30) {
            title
            message
            AppButton(width: .infinity, backgroundColor: warning ? AppColor.redradient : AppColor.darkButton, textColor: Color.white , text: confirmStr) {
                if confim != nil {
                    confim?()
                }
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
                        if cancel != nil {
                            cancel?()
                        }
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
