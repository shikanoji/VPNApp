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
    func onReceiveAlert(title: Binding<String>, message: Binding<String>, showing: Binding<Bool>) -> some View { modifier(ReceiveAlert(title: title, message: message, showing: showing))}
    
    func onReceiveAlertWithAction(title: Binding<String>, message: Binding<String>, showing: Binding<Bool>, onConfirm: @escaping () -> Void) -> some View {
        modifier(ReceiveAlertWithAction(title: title, message: message, showing: showing, onConfirmation: onConfirm))
    }
    
    func endEditingOnTappingOutside() -> some View {
        modifier(EndEditingOnTappingOutside())
    }
    
    func navigationAppearance(backgroundColor: UIColor, foregroundColor: UIColor, tintColor: UIColor? = nil, hideSeparator: Bool = false) -> some View {
        self.modifier(NavAppearanceModifier(backgroundColor: backgroundColor, foregroundColor: foregroundColor, tintColor: tintColor, hideSeparator: hideSeparator))
    }
}

extension View {
    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
        //    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        //        clipShape( RoundedCorner(radius: radius, corners: corners) )
        //    }
    }
}

extension Array {
    func getPosition(_ i: Int) -> PositionItemCell {
        let count = self.count
        if count == 0 || count == 1  {
            return .all
        } else if count - 1 == i {
            return .bot
        } else if i == 0 && count > 1 {
            return .top
        } else {
            return .middle
        }
    }
}
