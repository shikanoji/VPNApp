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
                Spacer().frame(height: 80)
                Image("welcome")
                Spacer().frame(height: 10)
                Text(LocalizedStringKey.Welcome.title.localized).setTitle()
                Spacer().frame(height: 10)
                Text(LocalizedStringKey.Welcome.message.localized).setDefault()
                Spacer()
                AppButton(width: 311, text: LocalizedStringKey.Welcome.startButton.localized) {
                    showingSetup = true
                }
                Spacer().frame(height: 20)
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
