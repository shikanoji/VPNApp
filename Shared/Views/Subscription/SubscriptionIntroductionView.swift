//
//  SubscriptionIntroductionView.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 13/01/2022.
//

import Foundation
import SwiftUI

struct SubscriptionIntroduction: View {
    var body: some View {
        Background {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center) {
                    Spacer().frame(height: 80)
                    Text(LocalizedStringKey.SubscriptionIntro.title.localized).setTitle()
                    Image("Subscription-Intro-Image")
                    Group {
                        Spacer().frame(height: 20)
                        HStack{
                            Image("unlimited")
                            Text(LocalizedStringKey.SubscriptionIntro.unlimited.localized).setDefault()
                            Spacer()
                        }.frame(width: 250)
                        HStack{
                            Image("cash-return")
                            Text(LocalizedStringKey.SubscriptionIntro.cashback.localized).setDefault()
                            Spacer()
                        }.frame(width: 250)
                        HStack{
                            Image("rocket-fast")
                            Text(LocalizedStringKey.SubscriptionIntro.rocketFast.localized).setDefault()
                            Spacer()
                        }.frame(width: 250)
                        HStack{
                            Image("live-support")
                            Text(LocalizedStringKey.SubscriptionIntro.liveSupport.localized).setDefault()
                            Spacer()
                        }.frame(width: 250)
                        Spacer().frame(height: 30)
                    }
                    AppButton(width: 300, text: LocalizedStringKey.SubscriptionIntro.startFreeTrial.localized) {
                        
                    }
                    Spacer().frame(height: 20)
                    AppButton(width: 250, backgroundColor: Color.clear, textColor: AppColor.lightBlackText, text: LocalizedStringKey.SubscriptionIntro.continueWithoutSub.localized) {
                        
                    }
                    Spacer().frame(height: 15)
                    Text(LocalizedStringKey.SubscriptionIntro.note.localized).setLightBlackText().frame(width: 300)
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
