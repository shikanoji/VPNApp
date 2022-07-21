//
//  EmbedWebView.swift
//  SysVPN
//
//  Created by Nguyen Dinh Thach on 21/07/2022.
//

import Foundation
import WebKit
import SwiftUI

struct EmbedWebView: View {
    @State var webViewFinishedLoading = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var url: String
    var title: String
    var body: some View {
        VStack {
            Spacer().frame(height: 80)
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
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(title)
        .background(AppColor.background)
        .ignoresSafeArea()
    }
}
