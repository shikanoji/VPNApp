//
//  SetupVPNView.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 18/01/2022.
//

import Foundation
import SwiftUI

struct SetupVPNView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authentication: Authentication

    var body: some View {
        ZStack {
            Background{}.opacity(0.8)
            VStack {
                Spacer().frame(height: 40)
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Asset.Assets.close.SuImage
                    }
                    Spacer()
                }
                Spacer()
                VStack {
                    Text(L10n.Welcome.setupVPN).setTitle()
                    Spacer().frame(height:10)
                    Text(L10n.Welcome.setupVPNMessage).setDefault()
                    Spacer().frame(height: 30)
                    AppButton(width: 311, text: L10n.Welcome.setupButton) {
                        presentationMode.wrappedValue.dismiss()
                        AppSetting.shared.isPremium = true
                        authentication.isPremium = AppSetting.shared.isPremium
                    }
                    Spacer().frame(height: 5)
                }
                .frame(width: UIScreen.main.bounds.width, height: 222)
                .background(Color.black)
                .cornerRadius(radius: 15, corners: [.topLeft, .topRight])
            }
        }
        .background(PopupBackgroundView())
        .ignoresSafeArea()
    }
}

#if DEBUG
struct SetupVPNView_Preview: PreviewProvider {
    static var previews: some View {
        SetupVPNView()
    }
}
#endif
