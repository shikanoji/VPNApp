//
//  Background.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 16/12/2021.
//

import Foundation
import SwiftUI

struct Background<Content: View>: View {
    private var content: Content
    var width: CGFloat
    var height: CGFloat

    init(width: CGFloat, height: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self.width = width
        self.height = height
    }

    var body: some View {
        AppColor.background
            .frame(width: width, height: height)
        .overlay(content)
        .ignoresSafeArea()
    }
}
