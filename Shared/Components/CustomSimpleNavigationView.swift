//
//  CustomSimpleNavigationView.swift
//  SysVPN
//
//  Created by Nguyen Dinh Thach on 12/09/2022.
//

import Foundation
import SwiftUI
struct CustomSimpleNavigationView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var title: String
    var backgroundColor: Color = AppColor.background
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    var showBackButton = true
    
    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: safeAreaInsets.top)
                if showBackButton {
                    HStack{
                        Spacer().frame(width: 15)
                        Label(L10n.Global.back, systemImage: "chevron.backward")
                            .foregroundColor(Color.white)
                            .onTapGesture {
                                presentationMode.wrappedValue.dismiss()
                            }
                        Spacer()
                    }
                }
            }
            VStack {
                Spacer().frame(height: safeAreaInsets.top)
                HStack {
                    Spacer()
                    Text(title).font(.system(size: Constant.TextSize.Global.titleMedium, weight: .bold))
                    Spacer()
                }
            }
        }
        .frame(height: 60 + safeAreaInsets.top)
        .background(backgroundColor)
    }
}
