//
//  BoardView.swift
//  SysVPN
//
//  Created by Phan Văn Đa on 17/12/2021.
//

import SwiftUI

struct BoardView: View {
    
    @StateObject var viewModel: BoardViewModel
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authentication: Authentication
    
    var body: some View {
        ZStack {
            VStack(spacing: 0.0) {
                BoardNavigationView(status: viewModel.state,
                                    tapLeftIcon: {
                    handlerTapLeftNavigation()
                }, tapRightIcon: {
                    handlerTapRightNavigation()
                })
                ZStack(alignment: .top) {
                    Color.red
                    VStack {
                        StatusVPNView(ip: viewModel.ip, status: viewModel.state)
                        Button("Logout") {
                            authentication.updateValidation(success: false)
                        }
                    }
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                }
                .background(Color.white)
                .frame(alignment: .top)
            }
            .preferredColorScheme(.dark)
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    func handlerTapLeftNavigation() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func handlerTapRightNavigation() {
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(viewModel: BoardViewModel())
    }
}
