//
//  AppButton.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 10/12/2021.
//

import Foundation
import SwiftUI

enum AppButtonStyle {
    case themeButton
    case darkButton
}
struct AppButton: View {
    var style: AppButtonStyle
    var width: CGFloat
    var height: CGFloat
    var backgroundColor: Color
    var textColor: Color
    var text: String
    var cornerRadius: CGFloat = 8
    var icon: Image?
    private let action: () -> Void
    
    init(style: AppButtonStyle = .themeButton, width: CGFloat = 200, height: CGFloat = 50, backgroundColor: Color = AppColor.themeColor, textColor: Color = AppColor.blackText, text: String = "", cornerRadius: CGFloat = 10, icon: Image? = nil, action: @escaping () -> Void) {
        self.style = style
        switch style {
        case .darkButton:
            self.backgroundColor = AppColor.darkButton
            self.textColor = Color.white
        default:
            self.backgroundColor = backgroundColor
            self.textColor = textColor
        }
        
        self.width = width
        self.height = height
        self.text = text
        self.cornerRadius = cornerRadius
        self.action = action
        self.icon = icon
    }
    
    var body: some View {
        Button {
            self.action()
        } label: {
            GeometryReader { geometric in
                HStack(alignment: .center, spacing: 10) {
                    if self.icon != nil {
                        self.icon
                    }
                    Text(text)
                        .foregroundColor(textColor)
                        .font(.system(size: 14, weight: .bold, design: .default))
                }.frame(width: geometric.size.width, height: geometric.size.height, alignment: .center)
            }
        }
        .frame(width: width, height: height)
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
    }
}

#if DEBUG
struct AppButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AppButton(width: 200, height: 50, text: "App Button") {
            }
            Spacer().frame(height: 20)
            AppButton(style: .darkButton, text: "Gray Button") {
            }
        }
    }
}
#endif
