//
//  Toast.swift
//  SysVPN (iOS)
//
//  Created by Nguyen Dinh Thach on 28/02/2022.
//

import Foundation
import SwiftUI

struct ToastView: View {
    struct Size {
        static let bodyTextSize: CGFloat = 12
        static let buttonHeight: CGFloat = 30
        static let buttonWidth: CGFloat = 120
    }
    let title: String
    let message: String
    var cancelAction: (() -> Void)? = nil
    var confirmAction: (() -> Void)? = nil
    var body: some View {
        VStack {
            Spacer().frame(height: 20)
            HStack(alignment: .top) {
                Spacer().frame(width: 10)
                VStack {
                    if !title.isEmpty {
                        Text(title).setDefaultBold()
                        Spacer().frame(height: 5)
                    }
                    Text(message)
                        .font(.system(size: Size.bodyTextSize, weight: .semibold))
                        .foregroundColor(AppColor.textColor)
                        .multilineTextAlignment(.center)
                }.frame(maxWidth: .infinity)
                Spacer().frame(width: 10)
                Image(systemName: "xmark.circle")
                    .foregroundColor(Color.white)
                    .onTapGesture {
                        cancelAction?()
                    }
                Spacer().frame(width: 10)
            }
            if confirmAction != nil {
                Spacer().frame(height: 10)
                HStack {
                    Spacer()
                    AppButton(
                        width: Size.buttonWidth, height: Size.buttonHeight,
                        backgroundColor: Color.clear,
                        textColor: Color.white,
                        textSize: Size.bodyTextSize,
                        text: L10n.Global.cancel,
                        borderWidth: 1,
                        borderColor: AppColor.lightGray) {
                            cancelAction?()
                        }
                    Spacer()
                    AppButton(
                        width: Size.buttonWidth, height: Size.buttonHeight,
                        backgroundColor: Color.clear,
                        textColor: Color.white,
                        textSize: Size.bodyTextSize,
                        text: L10n.Global.ok,
                        borderWidth: 1,
                        borderColor: AppColor.lightGray) {
                            confirmAction?()
                        }
                    Spacer()
                }
            }
            Spacer().frame(height: 20)
        }
        .frame(width: UIScreen.main.bounds.size.width - 40)
        .background(Color.black.opacity(0.8).blur(radius: 2))
        .cornerRadius(10)
    }
}

#if DEBUG
struct Toast_Preview: PreviewProvider {
    static var previews: some View {
        ToastView(title: "", message: "This is a test body This is a test body This is a test body This is a test body This is a test body This is a test body", confirmAction: {
            
        })
    }
}
#endif
