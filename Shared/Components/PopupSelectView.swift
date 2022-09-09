//
//  PopupSelectView.swift
//  SysVPN
//
//  Created by Da Phan Van on 09/08/2022.
//

import Foundation
import SwiftUI

struct PopupSelectView: View {
    struct Size {
        static let bodyTextSize: CGFloat = 13
        static let buttonHeight: CGFloat = 30
        static let buttonWidth: CGFloat = 120
    }
    var message: String = ""
    
    var cancelTitle = ""
    var confirmTitle = "DISMISS"
    
    var cancelAction: (() -> Void)? = nil
    var confirmAction: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 5) {
                if !message.isEmpty {
                    Text(message)
                        .font(.system(size: Size.bodyTextSize, weight: .semibold))
                        .foregroundColor(AppColor.textColor)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal)
            Spacer()
            if confirmAction != nil {
                HStack(spacing: 10) {
                    if cancelAction != nil {
                        Spacer()
                        AppButton(
                            width: Size.buttonWidth, height: Size.buttonHeight,
                            backgroundColor: Color.clear,
                            textColor: Color.white,
                            textSize: Size.bodyTextSize,
                            text: cancelTitle == "" ? L10n.Global.cancel : cancelTitle,
                            borderWidth: 1,
                            borderColor: AppColor.lightGray) {
                                cancelAction?()
                            }
                    }
                    AppButton(
                        width: Size.buttonWidth, height: Size.buttonHeight,
                        backgroundColor: Color.clear,
                        textColor: AppColor.themeColor,
                        textSize: Size.bodyTextSize,
                        text: confirmTitle == "" ? L10n.Global.ok : confirmTitle) {
                            confirmAction?()
                        }
                }
            }
        }
        .padding(.vertical, 15)
        .frame(width: UIScreen.main.bounds.size.width - 40)
        .background(Color.black.opacity(0.8).blur(radius: 2))
        .cornerRadius(15)
    }
}
