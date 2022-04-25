//
//  CustomPopupView.swift
//  SysVPN (iOS)
//
//  Created by Nguyen Dinh Thach on 09/03/2022.
//

import SwiftUI
///In case support iOS 13
struct CustomPopupView<Content, PopupView>: View where Content: View, PopupView: View {
    @Binding var isPresented: Bool
    @ViewBuilder let content: () -> Content
    @ViewBuilder let popupView: () -> PopupView
    let backgroundColor: Color
    let animation: Animation?
    var body: some View {
        content()
            .animation(nil, value: isPresented)
            .overlay(isPresented ? backgroundColor.edgesIgnoringSafeArea(.all) : nil)
            .onTapGesture {
                isPresented = false
            }
            .overlay(isPresented ? popupView() : nil)
            .animation(animation, value: isPresented)
    }
}
