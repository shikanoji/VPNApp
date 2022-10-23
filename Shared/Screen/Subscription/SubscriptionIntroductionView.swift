//
//  SubscriptionIntroductionView.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 13/01/2022.
//

import Foundation
import SwiftUI

struct SubscriptionIntroduction: View {
    @State var toPlanSelection: Bool = false
    @State var toWelcomeScreen: Bool = false
    
    let widthConent = Constant.Board.Map.widthScreen - 100
    
    var body: some View {
        Background {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center) {
                    Text(L10n.SubscriptionIntro.title).setTitle()
                    Asset.Assets.subscriptionIntroImage.swiftUIImage
                    Spacer().frame(height: 20)
                    HStack {
                        Asset.Assets.unlimited.swiftUIImage
                        Text(L10n.SubscriptionIntro.unlimited).setDefault()
                        Spacer()
                    }.frame(width: widthConent)
                    HStack {
                        Asset.Assets.cashReturn.swiftUIImage
                        Text(L10n.SubscriptionIntro.cashback).setDefault()
                        Spacer()
                    }.frame(width: widthConent)
                    HStack {
                        Asset.Assets.rocketFast.swiftUIImage
                        Text(L10n.SubscriptionIntro.rocketFast).setDefault()
                        Spacer()
                    }.frame(width: widthConent)
                    HStack {
                        Asset.Assets.liveSupport.swiftUIImage
                        Text(L10n.SubscriptionIntro.liveSupport).setDefault()
                        Spacer()
                    }.frame(width: widthConent)
                    Spacer().frame(height: 30)
                    Group {
                        NavigationLink(destination: PlanSelectionView(viewModel: PlanSelectionViewModel(shouldAllowLogout: true)),
                                       isActive: $toPlanSelection) {
                        }
                        AppButton(width: widthConent, text: L10n.SubscriptionIntro.startFreeTrial) {
                            toPlanSelection = true
                        }
                        Spacer().frame(height: 20)
                        NavigationLink(destination: WelcomeView(), isActive: $toWelcomeScreen) {
                        }
                        Spacer().frame(height: 15)
                    }
                    Text(L10n.SubscriptionIntro.note)
                        .foregroundColor(AppColor.lightBlackText)
                        .font(.system(size: Constant.TextSize.Global.subcription))
                        .frame(width: widthConent)
                }
                .frame(minHeight: UIScreen.main.bounds.height)
            }
        }
        .navigationBarHidden(true)
    }
}

#if DEBUG
struct SubscriptionIntroduction_Preview: PreviewProvider {
    static var previews: some View {
        SubscriptionIntroduction()
    }
}
#endif
