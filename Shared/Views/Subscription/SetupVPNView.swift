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
    @EnvironmentObject var registerResult: RegisterResultModel
    @EnvironmentObject var authentication: Authentication

    var body: some View {
        ZStack {
            Background{}.opacity(0.8)
            
            VStack {
                HStack {
                    Image("close").onTapGesture {
                        presentationMode.wrappedValue.dismiss()                    }
                    Spacer()
                }
                Spacer()
                VStack {
                    Text(LocalizedStringKey.Welcome.setupVPN.localized).setTitle()
                    Spacer().frame(height:10)
                    Text(LocalizedStringKey.Welcome.setupVPNMessage.localized).setDefault()
                    Spacer().frame(height: 30)
                    AppButton(width: 311, text: LocalizedStringKey.Welcome.setupButton.localized) {
                        presentationMode.wrappedValue.dismiss()
                        let email = registerResult.user.email
                        let accessToken = registerResult.tokens.access.token
                        let refreshToken = registerResult.tokens.refresh.token
                        if !email.isEmpty, !accessToken.isEmpty, !refreshToken.isEmpty {
                            authentication.login(email: email, accessToken: accessToken, refreshToken: refreshToken)
                        }
                        
                    }
                    Spacer().frame(height: 5)
                }
                .frame(width: UIScreen.main.bounds.width, height: 222)
                .background(Color.black)
                .cornerRadius(radius: 15, corners: [.topLeft, .topRight])            }
        }.background(BackgroundBlurView.init())
    }
}

#if DEBUG
struct SetupVPNView_Preview: PreviewProvider {
    static var previews: some View {
        SetupVPNView()
    }
}
#endif
