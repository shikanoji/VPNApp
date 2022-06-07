//
//  BoardNavigationView.swift
//  SysVPN (iOS)
//
//  Created by Phan Văn Đa on 19/12/2021.
//

import SwiftUI
import TunnelKitManager

struct BoardNavigationView: View {
    var status: VPNStatus
    
    let tapLeftIcon: () -> Void
    let tapRightIcon: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Image(Constant.Board.Image.setting)
                    .onTapGesture {
                        tapLeftIcon()
                    }
                    .frame(width: Constant.Board.IconFrame.leftIconWidth, height: Constant.Board.IconFrame.leftIconWidth)
                Spacer()
                Text(status.title)
                    .font(.system(size: Constant.Board.Navigation.sizeFont, weight: Constant.Board.Navigation.weightFont))
                    .foregroundColor(.white)
                Spacer()
                Image(Constant.Board.Image.user)
                    .frame(width: Constant.Board.IconFrame.rightIconWidth, height: Constant.Board.IconFrame.rightIconWidth)
                    .onTapGesture {
                        tapRightIcon()
                    }
            }
            .padding(.all, 5.0)
        }
        .frame(height: Constant.Board.Navigation.heightNavigationBar)
    }
}

struct BoardNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        BoardNavigationView(status: .connected, tapLeftIcon: {
            
        }, tapRightIcon: {
            
        })
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/400.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/60.0/*@END_MENU_TOKEN@*/))
    }
}
