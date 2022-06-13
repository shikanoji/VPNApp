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
    @Binding var statusConnect: VPNStatus
    @Binding var question: QuestionModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        
        VStack(spacing: 0) {
            AppColor.darkButton
                .padding(.horizontal)
            CustomNavigationView(
                tapLeftButton: {
                    presentationMode.wrappedValue.dismiss()
                }, tapRightButton: {
                    showAccount = false
                }, statusConnect: $statusConnect)
            ScrollView(.vertical, showsIndicators: false) {
                ZStack(alignment: .top) {
                    VStack(spacing: 0) {
                        Text(question.title)
                            .font(Constant.CustomNavigation.fontTitleNavigation)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(AppColor.darkButton)
                        if let url = URL(string: question.url) {
                            WebView(url: url)
                                .frame(height: Constant.Board.Map.heightScreen - Constant.Board.Navigation.heightNavigationBar)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .background(AppColor.background)
        .ignoresSafeArea()
    }
}
