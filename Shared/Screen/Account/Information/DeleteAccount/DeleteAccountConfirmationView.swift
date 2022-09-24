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
    var title: some View {
        HStack {
            Text(L10n.Account.deleteAccount)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color.white)
            Spacer()
        }
    }
    
    var note: some View {
        HStack {
            Text(L10n.Account.DeleteAccount.note)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(AppColor.yellowGradient)
            Spacer()
        }
    }
    
    var message: some View {
        Text(L10n.Account.DeleteAccount.message)
            .font(.system(size: 14, weight: .regular))
            .foregroundColor(Color.white)
    }
    
    var content: some View {
        VStack {
            title
            Spacer().frame(height:10)
            note
            Spacer().frame(height: 10)
            message
            Spacer().frame(height: 30)
            AppButton(width: .infinity, backgroundColor: AppColor.redradient, textColor: Color.white , text: L10n.Account.DeleteAccount.delete) {
                viewModel.deleteAccount()
            }
            Spacer().frame(height: 30)
        }
        .padding(20)
        .frame(width: UIScreen.main.bounds.width)
        .background(AppColor.background)
        .cornerRadius(radius: 15, corners: [.topLeft, .topRight])
    }
    
    var body: some View {
        ZStack {
            VStack {
                Color.clear
                content
                Spacer()
            }
            .onChange(of: viewModel.shouldDismissView) { shouldDismiss in
                if shouldDismiss {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .background(PopupBackgroundView())
        .ignoresSafeArea()
        .onAppear {
            /// Pass authentication to view model because Environment object only receivable through view
            viewModel.authentication = authentication
        }
        .popup(isPresented: $viewModel.showAlert, type: .floater(verticalPadding: 10), position: .bottom, animation: .easeInOut, autohideIn: 10, closeOnTap: false, closeOnTapOutside: true) {
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
