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
    @EnvironmentObject var authentication: Authentication
    @StateObject var viewModel: PlanSelectionViewModel
    let widthConent = Constant.Board.Map.widthScreen - 80
    
    var body: some View {
        LoadingScreen(isShowing: $viewModel.showProgressView) {
            Background {
                VStack {
                    CustomSimpleNavigationView(title: "", backgroundColor: .clear).opacity(viewModel.shouldAllowLogout ? 0 : 1)
                    Group {
                        Spacer().frame(height: 50)
                        Text(L10n.PlanSelect.title).setTitle()
                        Spacer().frame(height: 10)
                        Text(L10n.PlanSelect.body).setDefault()
                    }
                    
                    Group {
                        Spacer().frame(height: 20)
                        PlanListView(viewModel: viewModel.planListViewModel, widthConent: widthConent)
                        Spacer().frame(height: 20)
                    }
                    Group {
                        NavigationLink(destination: WelcomeView().navigationBarHidden(true),
                                       isActive: $viewModel.toWelcomeScreen) {
                        }
                        NavigationLink(destination: AccountLimitedView().navigationBarHidden(true),
                                       isActive: $viewModel.shouldShowAccountLimitedView) {
                        }
                        NavigationLink(destination: EmptyView()) {
                            EmptyView()
                        }
                    }
                    
                    AppButton(width: widthConent, text: L10n.PlanSelect.continueButton) {
#if DEBUG
                        viewModel.toWelcomeScreen = true
#else
                        viewModel.purchasePlan()
#endif
                    }
                    Spacer().frame(height: 20)
                    
                    Text(L10n.PlanSelect.notePlan).setDefault()

                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            authentication.logout()
                        } label: {
                            Text(L10n.Account.signout)
                            Asset.Assets.logout.swiftUIImage
                        }
                        .opacity(viewModel.shouldAllowLogout ? 1 : 0)
                        .foregroundColor(Color.white)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "chevron.backward").foregroundColor(.white)
                            Text(L10n.Global.back)
                        }
                        .opacity(viewModel.shouldAllowLogout ? 1 : 0)
                        .foregroundColor(Color.white)
                    }
                }
            }.onAppear(perform: {
                viewModel.loadPlans()
                viewModel.authentication = authentication
            })

            .popup(isPresented: $viewModel.showAlert, type: .floater(verticalPadding: 10), position: .bottom, animation: .easeInOut, autohideIn: 5, closeOnTap: false, closeOnTapOutside: true) {
                PopupSelectView(message: viewModel.alertMessage, confirmTitle: "Retry", confirmAction: {
                    Task {
                        await viewModel.verifyReceipt()
                    }
                })
            }
        }
        .navigationBarHidden(!viewModel.shouldAllowLogout)
        .navigationBarBackButtonHidden(true)
    }
}

#if DEBUG
struct PlanSelectionView_Preview: PreviewProvider {
    static var previews: some View {
        PlanSelectionView(viewModel: PlanSelectionViewModel())
    }
}
#endif
