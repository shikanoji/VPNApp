//
//  ConnectButton.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 22/12/2021.
//

import SwiftUI
import Combine
import TunnelKitManager

struct ConnectButton: View {
    var status: VPNStatus
    var uploadSpeed: String
    var downloadSpeed: String
    
    let widthSpeed = (UIScreen.main.bounds.width - Constant.Board.QuickButton.widthSize - 30) / 2
    
    @State var startAlertScroll = false
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            Spacer()
                .frame(width: widthSpeed)
            VStack(spacing: 10) {
                if status == .connected {
                    getConnectAlert()
                        .padding(.bottom, startAlertScroll ? 0 : Constant.Board.Map.heightScreen / 3)
                        .onAppear {
                            startAlertScroll = true
                        }
                        .onDisappear {
                            startAlertScroll = false
                        }
                        .animation(Animation.easeInOut(duration: 0.7))
                        .frame(width: Constant.Board.QuickButton.widthSize * 2)
                }
                ZStack {
                    Circle()
                        .strokeBorder(Color.white, lineWidth: Constant.Board.QuickButton.widthBorderMax)
                        .frame(width: Constant.Board.QuickButton.widthSize,
                               height: Constant.Board.QuickButton.widthSize)
                        .background(Circle().foregroundColor(status == .connected ? Color.white : AppColor.themeColor))
                    getContentButton()
                }
                .frame(width: Constant.Board.QuickButton.widthSize,
                       height: Constant.Board.QuickButton.widthSize)
            }
            .frame(width:  Constant.Board.QuickButton.widthSize)
            SpeedConnectedView(uploadSpeed: uploadSpeed, downLoadSpeed: downloadSpeed)
                .opacity(status == .connected ? (NetworkManager.shared.selectConfig == .wireGuard ? 0 : 1) : 0)
                .frame(width: widthSpeed, height: Constant.Board.QuickButton.widthSize)
        }
    }
    
    func getConnectAlert() -> some View {
        AlertConnectView()
    }
    
    func getContentButton() -> some View {
        switch status {
        case .disconnected:
            return AnyView(Text(L10n.Board.quickUnConnect)
                            .foregroundColor(Color.black)
                            .multilineTextAlignment(.center)
                            .font(.system(size: 14, weight: .bold))
                            .padding())
        case .connecting, .disconnecting:
            return AnyView(getDocAnimation()
                            .padding())
        case .connected:
            return AnyView(
                TimeConnectedView()
            )
        }
    }
    
    @State private var bouncing = false
    
    func getDocAnimation() -> some View {
        return HStack(spacing: 5) {
            DocAnimationView(timeWait: 0.2)
            DocAnimationView(timeWait: 0.4)
            DocAnimationView(timeWait: 0.6)
        }
    }
}

struct DocAnimationView: View {
    @State private var change = false
    var timeWait: CGFloat
    
    var body: some View {
        Circle()
            .frame(width: Constant.Board.QuickButton.sizeDoc,
                   height: Constant.Board.QuickButton.sizeDoc)
            .offset(y: change ? 5 : -5)
            .foregroundColor(Color.black)
            .onAppear {
                self.change.toggle()
            }
            .animation(Animation.linear(duration: 0.5).repeatForever().delay(timeWait))
    }
}

struct TimeConnectedView: View {
    @StateObject var stopWatch = StopWatch()
    
    var body: some View {
        Text(self.stopWatch.stopWatchTime)
            .truncationMode(.middle)
            .foregroundColor(Color.black)
            .font(.system(size: 14, weight: .bold))
            .lineLimit(1)
            .frame(width: Constant.Board.QuickButton.heightSize + 5,
                   height: Constant.Board.QuickButton.heightSize + 5)
            .onAppear {
                if self.stopWatch.isPaused() {
                    self.stopWatch.start()
                }
            }
    }
}
