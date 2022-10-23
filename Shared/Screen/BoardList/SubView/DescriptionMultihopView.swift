//
//  DescriptionMultihopView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 08/02/2022.
//

import SwiftUI

struct DescriptionMultihopView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    VisualEffectView(effect: UIBlurEffect(style: .dark))
                        .opacity(0.95)
                    HStack {
                        Image(Constant.CustomNavigation.iconBack)
                            .onTapGesture {
                                presentationMode.wrappedValue.dismiss()
                            }
                        Spacer()
                    }
                    .padding(.top, 35.0)
                }
                VStack(alignment: .center) {
                    Group {
                        Spacer().frame(height: 32)
                        Text(L10n.Board.BoardList.MultiHop.what)
                            .font(Constant.ChangePassWord.fontTitle)
                        Text(L10n.Board.BoardList.MultiHop.contentMultiHop)
                            .font(Constant.ChangePassWord.fontSubContent)
                            .padding(.vertical)
                        Spacer().frame(height: 16)
                        AppButton(style: .darkButton, width: UIScreen.main.bounds.size.width - 32, text: L10n.Board.BoardList.MultiHop.gotIt) {
                            presentationMode.wrappedValue.dismiss()
                        }
                        Spacer().frame(height: 40)
                    }
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .background(AppColor.lightBlack)
                .cornerRadius(radius: Constant.Menu.radiusCell * 2, corners: [PositionItemCell.top.rectCorner])
                .padding(.top, -Constant.Menu.radiusCell * 2)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

struct DescriptionMultihopView_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionMultihopView()
    }
}
