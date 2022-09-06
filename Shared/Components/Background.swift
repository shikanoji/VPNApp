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

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }

    var body: some View {
        AppColor.lightBlack
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(content)
        .ignoresSafeArea()
        .navigationBarTitleDisplayMode(.inline)
    }
}
