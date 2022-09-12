//
//  Introduction.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 07/12/2021.
//

import Foundation
import SwiftUI
import UIKit
struct IntroductionView: View {
    @EnvironmentObject var authentication: Authentication
    @State var index = 0
    // test board screen
    var body: some View {
        Background() {
            VStack() {
                Spacer().frame(height: UIDevice.current.hasNotch ? 60 : 40)
                HStack {
                    Spacer().frame(width: 10)
                    Asset.Assets.logoSmall.swiftUIImage
                    Spacer()
                }
                Spacer()
                SlideIntroduction()
                AppButton(style: .themeButton, width: 300, height:50, text: L10n.Introduction.trialButton) {
                    AppSetting.shared.showedIntroduction = true
                    authentication.showedIntroduction = true
                }
                AppButton(style: .darkButton, width: 300, height:50, text: "Sign In") {
                    AppSetting.shared.showedIntroduction = true
                    authentication.showedIntroduction = true
                }
                Spacer()
                Text(L10n.Introduction.introBottomTitle)
                    .font(.system(size: 11))
                    .foregroundColor(.white)
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

struct IntroductionView_Preview: PreviewProvider {
    static var previews: some View {
        IntroductionView()
    }
}
