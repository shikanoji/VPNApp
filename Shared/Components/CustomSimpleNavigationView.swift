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
    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: UIDevice.current.hasNotch ? 40 : 0)
                HStack{
                    Spacer().frame(width: 15)
                    Label(L10n.Global.back, systemImage: "chevron.backward")
                        .foregroundColor(Color.white)
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                    Spacer()
                }.frame(height: 60)
            }
            VStack {
                Spacer().frame(height: UIDevice.current.hasNotch ? 40 : 0)
                HStack {
                    Spacer()
                    Text(title).font(.system(size: 16, weight: .bold))
                    Spacer()
                }.frame(height: 60)
            }
        }.background(backgroundColor)
    }
}
