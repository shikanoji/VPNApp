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
    @Binding var statusConnect: VPNStatus
    @StateObject var viewModel: FAQViewModel
    
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
                            showAccount = false
                        }, statusConnect: $statusConnect)
                    VStack(spacing: 1) {
                        ForEach(Array(viewModel.questions.enumerated()), id: \.offset) { index, item in
                            FAQCell(question: item, position: viewModel.questions.getPosition(index), onTap: {
                                //Handle tapping question
                            })
                        }
                    }
                    .padding(Constant.Menu.hozitalPaddingCell)
                    .padding(.top, Constant.Menu.topPaddingCell)
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        .background(AppColor.background)
        .ignoresSafeArea()
    }
}

#if DEBUG
struct FAQViewPreview: PreviewProvider {
    @State static var showAccount = true
    static var previews: some View {
        FAQView(showAccount: $showAccount, statusConnect: .constant(.connected), viewModel: FAQViewModel())
    }
}
#endif
