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
                        authentication.login(email: "abc", password: "abc")
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
