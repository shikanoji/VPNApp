//
//  LoadingView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 28/02/2022.
//

import SwiftUI

struct LoadingView: View {
    @Environment(\.presentationMode) var presentationMode
    
    static let maxRange = Constant.Loading.sizeCircle - 5
    static let minRange = -Constant.Loading.sizeCircle + 5
    
    @State private var offSetRight = minRange
    @State private var offSetLeft = maxRange
    
    var body: some View {
        ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .opacity(0.8)
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(AppColor.backgroundLoading)
                    .frame(
                        width: Constant.Loading.sizeLoading,
                        height: Constant.Loading.sizeLoading)
                Circle()
                    .foregroundColor(
                        offSetRight < LoadingView.maxRange ? AppColor.rightCircle : AppColor.leftCircle
                    )
                    .frame(
                        width: Constant.Loading.sizeCircle,
                        height: Constant.Loading.sizeCircle)
                    .offset(x: offSetRight)
                    .zIndex(offSetRight < LoadingView.maxRange ? 1 : 0)
                    .animation(Animation.easeInOut(duration: 0.7).repeatForever(autoreverses: true))
                
                Circle()
                    .foregroundColor(
                        offSetRight == LoadingView.maxRange ? AppColor.rightCircle : AppColor.leftCircle
                    )
                    .frame(
                        width: Constant.Loading.sizeCircle,
                        height: Constant.Loading.sizeCircle)
                    .offset(x: offSetLeft)
                    .animation(Animation.easeInOut(duration: 0.7).repeatForever(autoreverses: true))
                    .zIndex(offSetRight < LoadingView.maxRange ? 0 : 1)
            }
        }
        .onAppear {
            offSetRight = LoadingView.maxRange
            offSetLeft = LoadingView.minRange
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
