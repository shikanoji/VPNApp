//
//  EmbedWebView.swift
//  SysVPN
//
//  Created by Nguyen Dinh Thach on 21/07/2022.
//

import Foundation
import WebKit
import SwiftUI

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        (UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets ?? .zero).insets
    }
}

extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

private extension UIEdgeInsets {
    var insets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}

struct EmbedWebView: View {
    @State var webViewFinishedLoading = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var url: String
    var title: String

    var navigation: some View {
        ZStack {
            VStack {
                Spacer().frame(height: UIDevice.current.hasNotch ? 40 : 0)
                HStack{
                    Spacer().frame(width: 15)
                    Label(L10n.Global.back, systemImage: "chevron.backward")
                        .foregroundColor(Color.white)
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                    Spacer()
                }.frame(height: 60)
            }
            VStack {
                Spacer().frame(height: UIDevice.current.hasNotch ? 40 : 0)
                HStack {
                    Spacer()
                    Text(title).font(.system(size: 16, weight: .bold))
                    Spacer()
                }.frame(height: 60)
            }
        }.background(AppColor.background)
    }
    var body: some View {
        VStack {
            navigation
            ScrollView(.vertical, showsIndicators: false) {
                ZStack(alignment: .top) {
                    if !webViewFinishedLoading {
                        LoadingView()
                    }
                    VStack(spacing: 0) {
                        if let url = URL(string: url) {
                            WebView(url: url, finishedLoading: $webViewFinishedLoading)
                                .opacity(webViewFinishedLoading ? 1 : 0)
                        }
                    }
                    .frame(height: Constant.Board.Map.heightScreen - 80)
                }
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
}
