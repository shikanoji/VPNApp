//
//  NoticeView.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 05/01/2022.
//

import Foundation
import SwiftUI

struct NoticeView: View {
    @State var showIntroduction: Bool = false
    @State var showTermsAndCondition: Bool = false
    @State var showPrivacyPolicies: Bool = false
    var body: some View {
        ZStack {
            Background() {
            }
            
            VStack{
                Asset.Assets.lock.SuImage
                Spacer().frame(height: 20)
                Text(L10n.Notice.title).setTitle()
                Group {
                    Spacer().frame(height: 20)
                    Text(L10n.Notice.firstGraph).setLightBlackText()
                    Spacer().frame(height: 20)
                    HStack(alignment: .firstTextBaseline) {
                        Asset.Assets.checkmark.SuImage
                        Spacer().frame(width: 10)
                        Text(L10n.Notice.firstTerm).setLightBlackText()
                        Spacer()
                    }
                    Spacer().frame(height: 20)
                    HStack(alignment: .firstTextBaseline) {
                        Asset.Assets.checkmark.SuImage
                        Spacer().frame(width: 10)
                        Text(L10n.Notice.secondTerm).setLightBlackText()
                        Spacer()
                    }
                    Spacer().frame(height: 20)
                }
                Group {
                    Text(L10n.Notice.lastGraph).setLightBlackText()
                    Spacer().frame(height: 10)
                    Text(L10n.Notice.agreement).setLightBlackText()
                    Spacer().frame(height: 5)
                    HStack {
                        Text(L10n.Notice.termOfService)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color.white)
                            .underline()
                            .onTapGesture {
                                showTermsAndCondition = true
                            }
                        Spacer().frame(width: 5)
                        Text(L10n.Notice.and).setLightBlackText()
                        Spacer().frame(width: 5)
                        Text(L10n.Notice.privacyPolicy)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color.white)
                            .underline()
                            .onTapGesture {
                                showPrivacyPolicies = true
                            }
                        Spacer()
                    }
                    Spacer().frame(height: 20)
                }
                Group {
                    NavigationLink(destination: EmbedWebView(url: Constant.api.termsAndConditionsURL,
                                                             title: L10n.Settings.termAndCondition),
                                   isActive: $showTermsAndCondition) {}
                    NavigationLink(destination: EmbedWebView(url: Constant.api.privacyPolictyURL,
                                                             title: L10n.Settings.privacyPolicty),
                                   isActive: $showPrivacyPolicies) {}
                    NavigationLink(destination: IntroductionView(), isActive: $showIntroduction) {}
                }
                
                AppButton(width: 295, text: L10n.Notice.buttonText){
                    AppSetting.shared.showedNotice = true
                    showIntroduction = true
                }
            }
            .padding(20)
            .frame(width: 343)
            .background(AppColor.lightBlack)
            .cornerRadius(15)
        }
        .navigationBarHidden(true)
    }
}

#if DEBUG
struct NoticeView_Preview: PreviewProvider {
    static var previews: some View {
        NoticeView()
    }
}
#endif
