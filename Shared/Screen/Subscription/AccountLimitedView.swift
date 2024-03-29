//
//  SubscriptionLinkedAlertView.swift
//  SysVPN (iOS)
//
//  Created by Nguyen Dinh Thach on 11/07/2022.
//

import Foundation
import SwiftUI

struct AccountLimitedView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authentication: Authentication

    var content: some View {
        VStack {
            Asset.Assets.accountLinked.swiftUIImage
            Spacer().frame(height: 20)
            Text(L10n.PlanSelect.accountLimit)
                .font(.system(size: Constant.TextSize.Global.titleLarge, weight: .bold))
                .foregroundColor(Asset.Colors.pink.swiftUIColor)
            Spacer().frame(height: 20)
            HStack {
                Spacer().frame(width: 30)
                Text(L10n.PlanSelect.accountLimitNote)
                    .font(.system(size: Constant.TextSize.Global.detailDefault, weight: .regular))
                    .foregroundColor(Color.white)
                Spacer().frame(width: 30)
            }
            Spacer().frame(height: 50)
            AppButton(width: 190, height: 50, backgroundColor: Color.white, textColor: Color.black, text: L10n.PlanSelect.gotIt) {
                // Handle
                authentication.logout()
            }
        }
    }
    var body: some View {
        Background {
            ZStack {
                Asset.Assets.redLinearGradient.swiftUIImage.resizable()
                VStack(spacing: 20) {
                    Spacer().frame(height: 40)
                    HStack {
                        Spacer().frame(width: 20)
                        Label(L10n.Global.back, systemImage: "chevron.backward")
                            .foregroundColor(Color.white)
                            .onTapGesture {
                                presentationMode.wrappedValue.dismiss()
                            }
                        Spacer()
                    }
                    Spacer()
                    content
                    Spacer()
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
        .navigationBarHidden(true)
    }
}
