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
}
