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
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    var body: some View {
        Background() {
            VStack() {
                Spacer().frame(height: UIDevice.current.hasNotch ? 60 : 40)
                HStack {
                    Spacer().frame(width: 32)
                    Asset.Assets.logoSmall.swiftUIImage
                    Spacer()
                }
                SlideIntroduction()
                Spacer()
                AppButton(style: .themeButton, width: Constant.Global.widthFormAndButton, height:50, text: L10n.Introduction.trialButton) {
                    authentication.needToShowRegisterScreenBeforeLogin = true
                    AppSetting.shared.showedIntroduction = true
                    authentication.showedIntroduction = true
                }
                AppButton(style: .darkButton, width: Constant.Global.widthFormAndButton, height:50, text: "Sign In") {
                    AppSetting.shared.showedIntroduction = true
                    authentication.showedIntroduction = true
                }
                Spacer()
                Text(L10n.Introduction.introBottomTitle)
                    .font(.system(size: 11))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.bottom, safeAreaInsets.bottom)
        }
        .navigationBarHidden(true)
    }
}

struct IntroductionView_Preview: PreviewProvider {
    static var previews: some View {
        IntroductionView()
    }
}
