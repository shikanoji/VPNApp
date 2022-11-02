//
//  FAQDetailView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 12/06/2022.
//

import SwiftUI
import TunnelKitManager

struct FAQDetailView: View {
    @Binding var showAccount: Bool
    @Binding var showFAQView: Bool
    @Binding var statusConnect: VPNStatus
    @Binding var question: QuestionModel
    @State var webViewFinishedLoading = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var title: some View {
        Text(question.title)
            .font(Constant.CustomNavigation.fontTitleNavigation)
            .foregroundColor(.white)
            .padding([.leading, .trailing, .bottom], 10)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(AppColor.darkButton)
    }

    var body: some View {
        VStack(spacing: 0) {
            AppColor.darkButton
                .frame(height: 20)
            CustomNavigationView(
                tapLeftButton: {
                    presentationMode.wrappedValue.dismiss()
                }, tapRightButton: {
                    showAccount = false
                    showFAQView = false
                }, statusConnect: $statusConnect)
            title
            if !webViewFinishedLoading {
                LoadingView()
            }
            if let url = URL(string: question.url) {
                WebView(url: url, finishedLoading: $webViewFinishedLoading)
                    .opacity(webViewFinishedLoading ? 1 : 0)
            }
        }
        .navigationBarHidden(true)
        .background(AppColor.background)
        .ignoresSafeArea()
    }
}
