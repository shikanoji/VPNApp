//
//  CustomNavigationView.swift
//  SysVPN
//
//  Created by Da Phan Van on 14/01/2022.
//

import SwiftUI
import TunnelKitManager

struct CustomNavigationView: View {
    
    @State var leftTitle = ""
    @State var currentTitle = ""
    
    let tapLeftButton: () -> Void
    let tapRightButton: () -> Void
    
    @State var statusConnect: VPNStatus
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    tapLeftButton()
                } label: {
                    if leftTitle == "" {
                        Image(Constant.CustomNavigation.iconBack)
                    } else {
                        Image(Constant.CustomNavigation.iconLeft)
                        Text(leftTitle)
                            .foregroundColor(.white)
                            .font(Constant.Account.fontEmail)
                            .padding()
                    }
                }
                .padding(.leading, 10.0)
                Spacer()
                Button  {
                    tapRightButton()
                } label: {
                    Text("VPN Connected")
                        .foregroundColor(AppColor.VPNConnected)
                        .font(Constant.Account.fontRightNavigation)
                    Image(Constant.CustomNavigation.iconRightConnect)
                }
                .padding()
            }
            if currentTitle != "" {
                HStack {
                    Text(currentTitle)
                        .font(Constant.CustomNavigation.fontTitleNavigation)
                        .foregroundColor(.white)
                        .padding(.leading)
                    Spacer()
                }
            }
        }
        .padding(.vertical)
        .background(AppColor.darkButton)
        .frame(height: Constant.Board.Navigation.heightNavigationBar + (currentTitle != "" ? Constant.CustomNavigation.heightCurrentTitle : 0))
    }
}

struct CustomNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavigationView(currentTitle: "Information",tapLeftButton: {
            
        }, tapRightButton: {
            
        }, statusConnect: .connected)
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/365.0/*@END_MENU_TOKEN@*/, height: Constant.Board.Navigation.heightNavigationBar + ("Information" != "" ? Constant.CustomNavigation.heightCurrentTitle : 0)))
    }
}
