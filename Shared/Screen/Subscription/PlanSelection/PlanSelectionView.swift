//
//  PlanSelectionView.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 13/01/2022.
//

import Foundation
import SwiftUI

struct PlanSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: PlanSelectionViewModel
    @State var toWelcomeScreen = false
    @State var shouldShowAccountLinkedAlertView = false
    var body: some View {
        LoadingScreen(isShowing: $viewModel.showProgressView) {
            Background {
                VStack {
                    Spacer()
                    Spacer().frame(height: 50)
                    Group {
                        Text(L10n.PlanSelect.title).setTitle()
                        Spacer().frame(height: 10)
                        Text(L10n.PlanSelect.body).setDefault()
                    }
                    
                    Group {
                        Spacer().frame(height: 20)
                        PlanListView(viewModel: viewModel.planListViewModel)
                        Spacer().frame(height: 20)
                    }
                    NavigationLink(destination: WelcomeView().navigationBarHidden(true),
                                   isActive: $viewModel.toWelcomeScreen) {
                    }
                    NavigationLink(destination: SubscriptionLinkedAlertView().navigationBarHidden(true),
                                   isActive: $shouldShowAccountLinkedAlertView) {
                    }
                    AppButton(width: 311, text: L10n.PlanSelect.continueButton) {
                        #if DEBUG
                        viewModel.toWelcomeScreen = true
                        #else
                        viewModel.purchasePlan()
                        #endif
                    }
                    Spacer().frame(height: 20)
                    Text(viewModel.planListViewModel.selectedPlan?.note ?? "")
                        .font(.system(size: 11))
                        .foregroundColor(Color.white)
                        .frame(width: 320, height: 40)
                    Spacer()
                }
            }.onAppear(perform: {
                viewModel.loadPlans()
            })
        }
    }
}

#if DEBUG
struct PlanSelectionView_Preview: PreviewProvider {
    static var previews: some View {
        PlanSelectionView(viewModel: PlanSelectionViewModel())
    }
}
#endif
