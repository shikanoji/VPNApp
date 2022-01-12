//
//  TextExtension.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 16/12/2021.
//

import Foundation
import SwiftUI

extension Text {
    func setDefault() -> some View {
        modifier(DefaultLabel())
    }
    
    func setDefaultBold() -> some View {
        modifier(DefaultBold())
    }
    
    func setTitle() -> some View {
        modifier(TitleLabel())
    }
    
    func setLightBlackText() -> some View {
        modifier(LightBlackText())
    }
}

struct AnimatableSystemFontModifier: AnimatableModifier {
    var size: CGFloat
    var weight: Font.Weight
    var design: Font.Design

    var animatableData: CGFloat {
        get { size }
        set { size = newValue }
    }

    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: weight, design: design))
    }
}

extension View {
    func animatableSystemFont(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> some View {
        self.modifier(AnimatableSystemFontModifier(size: size, weight: weight, design: design))
    }
}
