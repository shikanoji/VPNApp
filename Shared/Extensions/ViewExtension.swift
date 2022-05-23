//
//  ViewExtension.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 02/12/2021.
//

import SwiftUI
extension View {
    func iOS<Content: View>(_ modifier: (Self) -> Content) -> some View {
#if os(iOS)
        return modifier(self)
#else
        return self
#endif
    }
}

extension View {
    func macOS<Content: View>(_ modifier: (Self) -> Content) -> some View {
#if os(macOS)
        return modifier(self)
#else
        return self
#endif
    }
}

extension View {
    func tvOS<Content: View>(_ modifier: (Self) -> Content) -> some View {
#if os(tvOS)
        return modifier(self)
#else
        return self
#endif
    }
}

extension View {
    func watchOS<Content: View>(_ modifier: (Self) -> Content) -> some View {
#if os(watchOS)
        return modifier(self)
#else
        return self
#endif
    }
}

extension View {
    func navigationAppearance(backgroundColor: UIColor, foregroundColor: UIColor, tintColor: UIColor? = nil, hideSeparator: Bool = false) -> some View {
        self.modifier(NavAppearanceModifier(backgroundColor: backgroundColor, foregroundColor: foregroundColor, tintColor: tintColor, hideSeparator: hideSeparator))
    }
}

extension View {
    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}

extension View {
    func customPopupView<PopupView>(isPresented: Binding<Bool>,
                                    popupView: @escaping () -> PopupView,
                                    backgroundColor: Color = .black.opacity(0.7),
                                    animation: Animation? = .default) -> some View where PopupView: View {
        let customPopupView = CustomPopupView(isPresented: isPresented,
                                              content: { self },
                                              popupView: popupView,
                                              backgroundColor: backgroundColor,
                                              animation: animation)
        return customPopupView
    }
}

extension View {
    func clearModalBackground()->some View {
        self.modifier(ClearBackgroundViewModifier())
    }
}

extension View {
    func keyboardAdaptive() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAdaptive())
    }
}
