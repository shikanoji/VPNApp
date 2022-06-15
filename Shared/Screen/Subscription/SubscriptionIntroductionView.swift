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
    var body: some View {
        Background {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center) {
                    Spacer()
                    Text(L10n.SubscriptionIntro.title).setTitle()
                    Asset.Assets.subscriptionIntroImage.SuImage
                    Group {
                        Spacer().frame(height: 20)
                        HStack{
                            Asset.Assets.unlimited.SuImage
                            Text(L10n.SubscriptionIntro.unlimited).setDefault()
                            Spacer()
                        }.frame(width: 250)
                        HStack{
                            Asset.Assets.cashReturn.SuImage
                            Text(L10n.SubscriptionIntro.cashback).setDefault()
                            Spacer()
                        }.frame(width: 250)
                        HStack{
                            Asset.Assets.rocketFast.SuImage
                            Text(L10n.SubscriptionIntro.rocketFast).setDefault()
                            Spacer()
                        }.frame(width: 250)
                        HStack{
                            Asset.Assets.liveSupport.SuImage
                            Text(L10n.SubscriptionIntro.liveSupport).setDefault()
                            Spacer()
                        }.frame(width: 250)
                        Spacer().frame(height: 30)
                    }
                    Group {
                        NavigationLink(destination: PlanSelectionView(), isActive: $toPlanSelection) {
                        }
                        AppButton(width: 300, text: L10n.SubscriptionIntro.startFreeTrial) {
                            toPlanSelection = true
                        }
                        Spacer().frame(height: 20)
                        NavigationLink(destination: WelcomeView(), isActive: $toWelcomeScreen) {
                        }
//                        AppButton(width: 250, backgroundColor: Color.clear, textColor: AppColor.lightBlackText, text: L10n.SubscriptionIntro.continueWithoutSub) {
//                            toWelcomeScreen = true
//                        }
                        Spacer().frame(height: 15)
                    }
                    Text(L10n.SubscriptionIntro.note).foregroundColor(AppColor.lightBlackText).font(.system(size: 11)).frame(width: 300)
                    Spacer()
                }
                .frame(minHeight: UIScreen.main.bounds.height)
            }
        }
    }
}

#if DEBUG
struct SubscriptionIntroduction_Preview: PreviewProvider {
    static var previews: some View {
        SubscriptionIntroduction()
    }
}
#endif
