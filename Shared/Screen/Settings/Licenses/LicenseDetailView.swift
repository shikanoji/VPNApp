//
//  LicenseDetailView.swift
//  SysVPN
//
//  Created by Nguyen Dinh Thach on 21/07/2022.
//

import Foundation
import SwiftUI

struct LicenseDetailView: View {
    @StateObject var viewModel: LicenseDetailViewModel
    var body: some View {
        VStack {
            CustomSimpleNavigationView(title: viewModel.license.title ?? "")
                .padding(.bottom, -10)
            ScrollView(.vertical, showsIndicators: false) {
                ZStack(alignment: .top) {
                    VStack(spacing: 1) {
                        HStack {
                            Spacer().frame(width: 20)
                            Text(viewModel.licenseText)
                            Spacer().frame(width: 20)
                        }
                        Spacer().frame(height: 40)
                    }.frame(height: Constant.Board.Map.heightScreen - 80)
                }
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea()
        .onAppear(perform: {
            viewModel.loadLicenseDetail()
        })
    }
}
