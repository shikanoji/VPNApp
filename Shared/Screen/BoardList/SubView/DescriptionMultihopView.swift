//
//  DescriptionMultihopView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 08/02/2022.
//

import SwiftUI

struct DescriptionMultihopView: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var cancel: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 0) {
            AppColor.darkButton.opacity(0.2)
                .contentShape(Rectangle())
                .onTapGesture {
                    cancel?()
                }
            VStack {
                LedgeTopView()
                    .padding(.top, -10)
                Spacer().frame(height: 32)
                Text(L10n.Board.BoardList.MultiHop.what)
                    .font(Constant.ChangePassWord.fontTitle)
                    .padding(.horizontal, 20)
                Text(L10n.Board.BoardList.MultiHop.contentMultiHop)
                    .font(Constant.ChangePassWord.fontSubContent)
                    .padding(.vertical)
                    .padding(.horizontal, 20)
                Spacer().frame(height: 16)
                AppButton(style: .darkButton,width: UIScreen.main.bounds.size.width - 32, text: L10n.Board.BoardList.MultiHop.gotIt) {
                    if cancel != nil {
                        cancel?()
                    }
                }
                .padding(.bottom, 20)
            }
            .foregroundColor(.white)
            .background(AppColor.blackText)
            .cornerRadius(radius: 20, corners: [.topLeft, .topRight])
        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onEnded({ value in
                if value.translation.height > 10 {
                    cancel?()
                }
            }))
        .background(PopupBackgroundView())
        .ignoresSafeArea()
    }
}

struct DescriptionMultihopView_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionMultihopView()
    }
}
