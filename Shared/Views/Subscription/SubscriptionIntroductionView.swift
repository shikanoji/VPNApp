//
//  SubscriptionIntroductionView.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 13/01/2022.
//

import Foundation
import SwiftUI

struct SubscriptionIntroduction: View {
    @EnvironmentObject var registerResult: RegisterResultModel
    @State var toPlanSelection: Bool = false
    @State var toWelcomeScreen: Bool = false
    var body: some View {
        Background {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center) {
                    Spacer().frame(height: 90)
                    Text(LocalizedStringKey.SubscriptionIntro.title.localized).setTitle()
                    Asset.Assets.subscriptionIntroImage.SuImage
                    Group {
                        Spacer().frame(height: 20)
                        HStack{
                            Asset.Assets.unlimited.SuImage
                            Text(LocalizedStringKey.SubscriptionIntro.unlimited.localized).setDefault()
                            Spacer()
                        }.frame(width: 250)
                        HStack{
                            Asset.Assets.cashReturn.SuImage
                            Text(LocalizedStringKey.SubscriptionIntro.cashback.localized).setDefault()
                            Spacer()
                        }.frame(width: 250)
                        HStack{
                            Asset.Assets.rocketFast.SuImage
                            Text(LocalizedStringKey.SubscriptionIntro.rocketFast.localized).setDefault()
                            Spacer()
                        }.frame(width: 250)
                        HStack{
                            Asset.Assets.liveSupport.SuImage
                            Text(LocalizedStringKey.SubscriptionIntro.liveSupport.localized).setDefault()
                            Spacer()
                        }.frame(width: 250)
                        Spacer().frame(height: 30)
                    }
                    Group {
                        NavigationLink(destination: PlanSelectionView().environmentObject(registerResult), isActive: $toPlanSelection) {
                        }
                        AppButton(width: 300, text: LocalizedStringKey.SubscriptionIntro.startFreeTrial.localized) {
                            toPlanSelection = true
                        }
                        Spacer().frame(height: 20)
                        NavigationLink(destination: WelcomeView().environmentObject(registerResult), isActive: $toWelcomeScreen) {
                        }
                        AppButton(width: 250, backgroundColor: Color.clear, textColor: AppColor.lightBlackText, text: LocalizedStringKey.SubscriptionIntro.continueWithoutSub.localized) {
                            toWelcomeScreen = true
                        }
                        Spacer().frame(height: 15)
                    }
                    Text(LocalizedStringKey.SubscriptionIntro.note.localized).foregroundColor(AppColor.lightBlackText).font(.system(size: 11)).frame(width: 300)
                    Spacer().frame(height: 20)
                }
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
