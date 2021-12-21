//
//  TextModifier.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 02/12/2021.
//

import SwiftUI

struct DefaultLabel: ViewModifier {
    func body(content: Content) -> some View {
        content.foregroundColor(Color.white).font(.system(size: 14))
    }
}

struct DefaultBold: ViewModifier {
    func body(content: Content) -> some View {
        content.foregroundColor(Color.white).font(.system(size: 14, weight: .bold))
    }
}

struct TitleLabel: ViewModifier {
    func body(content: Content) -> some View {
        content.foregroundColor(Color.white).font(.system(size: 24, weight: .bold))
    }
}
