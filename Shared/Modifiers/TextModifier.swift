//
//  TextModifier.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 02/12/2021.
//

import SwiftUI

struct DefaultLabel: ViewModifier {
    func body(content: Content) -> some View {
        content.foregroundColor(Color(hex: "3f3f3f"))
    }
}
