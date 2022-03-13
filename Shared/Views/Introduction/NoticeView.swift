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
    var body: some View {
        ZStack {
            Background() {
            }
            
            VStack{
                Asset.Assets.lock.SuImage
                Spacer().frame(height: 20)
                Text(LocalizedStringKey.Notice.title.localized).setTitle()
                Group {
                    Spacer().frame(height: 20)
                    Text(LocalizedStringKey.Notice.firstGraph.localized).setLightBlackText()
                    Spacer().frame(height: 20)
                    HStack(alignment: .firstTextBaseline) {
                        Asset.Assets.checkmark.SuImage
                        Spacer().frame(width: 10)
                        Text(LocalizedStringKey.Notice.firstTerm.localized).setLightBlackText()
                        Spacer()
                    }
                    Spacer().frame(height: 20)
                    HStack(alignment: .firstTextBaseline) {
                        Asset.Assets.checkmark.SuImage
                        Spacer().frame(width: 10)
                        Text(LocalizedStringKey.Notice.secondTerm.localized).setLightBlackText()
                        Spacer()
                    }
                    Spacer().frame(height: 20)
                }
                Text(LocalizedStringKey.Notice.lastGraph.localized).setLightBlackText()
                Spacer().frame(height: 20)
                NavigationLink(destination: IntroductionView(), isActive: $showIntroduction) {
                }
                AppButton(width: 295, text: LocalizedStringKey.Notice.buttonText.localized){
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
