//
//  LicenseDetailView.swift
//  SysVPN
//
//  Created by Nguyen Dinh Thach on 21/07/2022.
//

import Foundation
import SwiftUI

struct LicenseDetailView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @StateObject var viewModel: LicenseDetailViewModel
    var body: some View {
        VStack {
            Spacer().frame(height: 70)
            ScrollView(.vertical, showsIndicators: false) {
                ZStack(alignment: .top) {
                    VStack(spacing: 1) {
                        HStack {
                            Spacer().frame(width: 20)
                            Text(viewModel.licenseText)
                            Spacer().frame(width: 20)
                        }
                        Spacer().frame(height: 40)
                    }
                }
            }
            .frame(height: UIScreen.main.bounds.height - 60)
            .clipped()
        }
        .padding(.bottom, safeAreaInsets.bottom)
        .background(AppColor.background)
        .navigationBarTitle(viewModel.license.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea()
        .onAppear(perform: {
            viewModel.loadLicenseDetail()
        })
    }
}
