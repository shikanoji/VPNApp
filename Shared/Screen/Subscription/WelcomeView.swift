//
//  WelcomeView.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 18/01/2022.
//

import Foundation
import SwiftUI

struct WelcomeView: View {
    @State var showingSetup: Bool = false
    var body: some View {
        Background {
            VStack {
                Spacer()
                Asset.Assets.welcome.SuImage
                Spacer().frame(height: 10)
                Text(L10n.Welcome.title).setTitle()
                Spacer().frame(height: 10)
                Text(L10n.Welcome.message).setDefault()
                Spacer()
                AppButton(width: 311, text: L10n.Welcome.startButton) {
                    showingSetup = true
                }
                Spacer()
            }
        }.fullScreenCover(isPresented: $showingSetup) {
            SetupVPNView()
        }
    }
}

struct WelcomeView_Preview: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
