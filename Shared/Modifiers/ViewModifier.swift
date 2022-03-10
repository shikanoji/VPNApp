//
//  ViewModifier.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 15/12/2021.
//

import Foundation
import SwiftUI

struct ReceiveAlert: ViewModifier {
    @Binding var title: String
    @Binding var message: String
    @Binding var showing: Bool
    func body(content: Content) -> some View {
        content.alert(isPresented: $showing) {
            Alert(
                title: Text(title),
                message: Text(message)
            )
        }
    }
}

struct ReceiveAlertWithAction: ViewModifier {
    @Binding var title: String
    @Binding var message: String
    @Binding var showing: Bool
    var onConfirmation: () -> Void
    
    func body(content: Content) -> some View {
        content.alert(isPresented: $showing) {
            Alert(
                title: Text(title),
                message: Text(message),
                primaryButton: .destructive(Text("OK")) {
                                 onConfirmation()
                                },
                secondaryButton: .cancel()
            )
        }
    }
}

struct EndEditingOnTappingOutside: ViewModifier {
    func body(content: Content) -> some View {
        content.onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner

    struct CornerRadiusShape: Shape {
        var radius = CGFloat.infinity
        var corners = UIRectCorner.allCorners
        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }

    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}
