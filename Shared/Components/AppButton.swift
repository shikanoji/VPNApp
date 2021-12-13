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
    case grayButton
}
struct AppButton: View {
    var style: AppButtonStyle
    var width: CGFloat
    var height: CGFloat
    var backgroundColor: Color
    var textColor: Color
    var text: String
    var cornerRadius: CGFloat = 10
    private let action: () -> Void
    
    init(style: AppButtonStyle = .themeButton, width: CGFloat = 200, height: CGFloat = 50, backgroundColor: Color = AppColor.blue, textColor: Color = Color.white, text: String = "", cornerRadius: CGFloat = 10, action: @escaping () -> Void) {
        self.style = style
        switch style {
        case .grayButton:
            self.backgroundColor = AppColor.gray
            self.textColor = Color.black
        default:
            self.backgroundColor = backgroundColor
            self.textColor = textColor
        }
        
        self.width = width
        self.height = height
        self.text = text
        self.cornerRadius = cornerRadius
        self.action = action
    }
    
    var body: some View {
        GeometryReader { geometric in
            HStack {
                Text(text)
                    .foregroundColor(textColor)
                    .font(.system(size: 14, weight: .bold, design: .default))
            }.frame(width: geometric.size.width, height: geometric.size.height, alignment: .center)
        }
        .frame(width: width, height: height)
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .onTapGesture {
            self.action()
        }
    }
}

#if DEBUG
struct AppButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AppButton(width: 200, height: 50, text: "App Button") {
            }
            Spacer().frame(height: 20)
            AppButton(style: .grayButton, text: "Gray Button") {
            }
        }
        
    }
}
#endif
