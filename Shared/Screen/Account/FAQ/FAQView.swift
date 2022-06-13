//
//  FrequentlyAskedQuestionsView.swift
//  SysVPN
//
//  Created by Nguyễn Đình Thạch on 08/02/2022.
//

import Foundation
import SwiftUI
import TunnelKitManager

struct FAQView: View {
    @Binding var showAccount: Bool
    @Binding var showFAQ: Bool
    @Binding var statusConnect: VPNStatus
    @StateObject var viewModel: FAQViewModel
    @State var showFAQDetail = false
    @State var faqSelect: QuestionModel!
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack(alignment: .top) {
                VStack {
                    AppColor.darkButton
                        .frame(height: 10)
                    CustomNavigationView(
                        leftTitle: L10n.Account.AccountStatus.title,
                        currentTitle: L10n.Faq.title,
                        tapLeftButton: {
                            presentationMode.wrappedValue.dismiss()
                        }, tapRightButton: {
                            showFAQ = false
                            showAccount = false
                        }, statusConnect: $statusConnect)
                    if viewModel.showProgressView {
                        LoadingView()
                            .padding(.top, UIScreen.main.bounds.size.height / 3)
                    } else {
                        VStack(spacing: 1) {
                            ForEach(viewModel.topicQuestionList, id: \.id) { topic in
                                Text(topic.name)
                                    .font(Constant.Menu.fontSectionTitle)
                                    .foregroundColor(AppColor.lightBlackText)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(Constant.Menu.hozitalPaddingCell)
                                    .padding(.top, Constant.Menu.topPaddingCell)
                                VStack(spacing: 1) {
                                    ForEach(topic.faqs, id: \.id) { faq in
                                        Button(action: {
                                            faqSelect = faq
                                            showFAQDetail = true
                                        }, label: {
                                            FAQCell(question: faq,
                                                    position: topic.faqs.getPosition(faq))
                                        })
                                    }
                                }
                                .padding(.horizontal , Constant.Menu.hozitalPaddingCell)
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        .background(AppColor.background)
        .ignoresSafeArea()
        .popup(isPresented: $viewModel.showAlert, type: .floater(verticalPadding: 10), position: .bottom, animation: .easeInOut, autohideIn: 10, closeOnTap: false, closeOnTapOutside: true) {
            ToastView(title: viewModel.error?.title ?? "",
                      message: viewModel.error?.description ?? "",
                      cancelAction: {
                viewModel.showAlert = false
            })
        }
        NavigationLink(destination:
                        FAQDetailView(
                            showAccount: $showAccount,
                            statusConnect: $statusConnect,
                            question: .constant(faqSelect ?? QuestionModel())),
                       isActive: $showFAQDetail) { }
    }
}

#if DEBUG
struct FAQViewPreview: PreviewProvider {
    @State static var showAccount = true
    static var previews: some View {
        FAQView(showAccount: $showAccount, showFAQ: .constant(false), statusConnect: .constant(.connected), viewModel: FAQViewModel())
    }
}
#endif
