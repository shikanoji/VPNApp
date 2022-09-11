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
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    var url: String
    var title: String
    var body: some View {
        VStack {
            Spacer().frame(height: 60)
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
        .padding(safeAreaInsets)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(title)
        .background(AppColor.background)
        .ignoresSafeArea()
    }
}
