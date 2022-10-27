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
    case none
}
struct AppButton: View {
    let style: AppButtonStyle
    let width: CGFloat
    let height: CGFloat
    let backgroundColor: Color
    let textColor: Color
    let textSize: CGFloat
    let text: String
    let cornerRadius: CGFloat
    let borderWidth: CGFloat
    let borderColor: Color
    let icon: Image?
    private let action: () -> Void

    init(style: AppButtonStyle = .none, width: CGFloat = 200, height: CGFloat = 50,
         backgroundColor: Color = AppColor.themeColor,
         textColor: Color = AppColor.blackText,
         textSize: CGFloat = Constant.TextSizeButton.Default.medium,
         text: String = "",
         cornerRadius: CGFloat = 10,
         borderWidth: CGFloat = 0,
         borderColor: Color = Color.clear,
         icon: Image? = nil,
         action: @escaping () -> Void) {
        self.style = style
        switch style {
        case .darkButton:
            self.backgroundColor = AppColor.darkButton
            self.textColor = Color.white
        case .themeButton:
            self.backgroundColor = AppColor.themeColor
            self.textColor = AppColor.blackText
        default:
            self.backgroundColor = backgroundColor
            self.textColor = textColor
        }

        self.width = width
        self.height = height
        self.text = text
        self.textSize = textSize
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.borderColor = borderColor
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
                        .font(.system(size: textSize, weight: .bold, design: .default))
                }.frame(width: geometric.size.width, height: geometric.size.height, alignment: .center)
            }
        }
        .frame(width: width, height: height)
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(borderColor, lineWidth: borderWidth)
        )
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
            Spacer().frame(height: 20)
            AppButton(backgroundColor: Color.gray, textColor: Color.white, text: "Custom button", borderWidth: 1, borderColor: AppColor.lightGray) {

            }
        }
    }
}
#endif
