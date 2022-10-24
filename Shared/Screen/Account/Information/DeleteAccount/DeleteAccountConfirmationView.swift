//
//  DeleteAccountConfirmationView.swift
//  SysVPN
//
//  Created by Nguyen Dinh Thach on 09/04/2022.
//

import Foundation
import SwiftUI

struct DeleteAccountConfirmationView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authentication: Authentication
    @StateObject var viewModel: DeleteAccountConfirmationViewModel
    
    var cancel: (() -> Void)? = nil
    
    var title: some View {
        HStack {
            Text(L10n.Account.deleteAccount)
                .font(.system(size: Constant.TextSize.Global.titleDefault, weight: .bold))
                .foregroundColor(Color.white)
            Spacer()
        }
    }
    
    var note: some View {
        HStack {
            Text(L10n.Account.DeleteAccount.note)
                .font(.system(size: Constant.TextSize.Global.detailDefault, weight: .regular))
                .foregroundColor(AppColor.yellowGradient)
            Spacer()
        }
    }
    
    var message: some View {
        Text(L10n.Account.DeleteAccount.message)
            .font(.system(size: Constant.TextSize.Global.detailDefault, weight: .regular))
            .foregroundColor(Color.white)
    }
    
    var content: some View {
        VStack {
            LedgeTopView()
                .padding(.top, -10)
            title
            Spacer().frame(height:10)
            note
            Spacer().frame(height: 10)
            message
            Spacer().frame(height: 30)
            AppButton(width: .infinity, backgroundColor: AppColor.redradient, textColor: Color.white , text: L10n.Account.DeleteAccount.delete) {
                viewModel.requestDeleteAccount()
            }
            Spacer().frame(height: 30)
        }
        .padding(20)
        .frame(width: UIScreen.main.bounds.width)
        .background(AppColor.background)
        .cornerRadius(radius: 15, corners: [.topLeft, .topRight])
    }
    
    var body: some View {
        LoadingScreen(isShowing: $viewModel.showProgressView) {
            VStack {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        cancel?()
                    }
                content
            }
        }
        .onChange(of: viewModel.shouldDismissView) { shouldDismiss in
            if shouldDismiss {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .background(PopupBackgroundView())
        .ignoresSafeArea()
        .onAppear {
            /// Pass authentication to view model because Environment object only receivable through view
            viewModel.authentication = authentication
        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onEnded({ value in
                if value.translation.height > 10 {
                    cancel?()
                }
            }))
        .popup(isPresented: $viewModel.showAlert, type: .floater(verticalPadding: 10), position: .bottom, animation: .easeInOut, autohideIn: 5, closeOnTap: false, closeOnTapOutside: true) {
            PopupSelectView(message: viewModel.alertMessage,
                            confirmAction: {
                                viewModel.showAlert = false
                            })
        }
    }
}

#if DEBUG
struct DeleteAccountConfirmationView_Preview: PreviewProvider {
    static var previews: some View {
        DeleteAccountConfirmationView(viewModel: DeleteAccountConfirmationViewModel())
    }
}
#endif
