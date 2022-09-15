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

    let widthSpeed = (UIScreen.main.bounds.width - Constant.Board.QuickButton.widthSize - 30) / 2
    
    @State var startAlertScroll = false
    
    @StateObject var viewModel: BoardViewModel
    
    @State var hiddenDelay = 1.0
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            if(viewModel.stateUI != .connected) {
                Spacer()
                    .frame(width: widthSpeed)
            }
            if(viewModel.stateUI == .connected) {
                TimeConnectedView().frame(width: widthSpeed, height: Constant.Board.QuickButton.widthSize)
                    .opacity(viewModel.stateUI == .connected ? 1 : 0)
            }
            VStack(spacing: 10) {
                if viewModel.stateUI == .connected {
                    getConnectAlert()
                        .padding(.bottom, 5)
                        .padding(.bottom, startAlertScroll ? 0 : Constant.Board.Map.heightScreen / 4)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                                startAlertScroll = true
                            })
                        }
                        .onDisappear {
                            startAlertScroll = false
                        }
                        .animation(Animation.easeInOut(duration: 0.5))
                        .frame(width: Constant.Board.QuickButton.widthSize * 2)
                        .opacity(!startAlertScroll ? 0 : 1)
                }
                ZStack {
                    Circle()
                        .strokeBorder(viewModel.stateUI == .disconnected ? Color.white : AppColor.themeColor, lineWidth: Constant.Board.QuickButton.widthBorderMax)
                        .frame(width: Constant.Board.QuickButton.widthSize + 20,
                               height: Constant.Board.QuickButton.widthSize + 20)
                        .background(Circle().foregroundColor(viewModel.stateUI == .disconnected ? AppColor.themeColor : Color.white))
                    Circle()
                        .strokeBorder(Color.black, lineWidth: Constant.Board.QuickButton.widthBorderMax)
                        .frame(width: Constant.Board.QuickButton.widthSize + 11,
                               height: Constant.Board.QuickButton.widthSize + 11)
                    getContentButton()
                }
                .frame(width: Constant.Board.QuickButton.widthSize,
                       height: Constant.Board.QuickButton.widthSize)
            }
            .frame(width:  Constant.Board.QuickButton.widthSize)
            SpeedConnectedView(uploadSpeed: viewModel.uploadSpeed, downLoadSpeed: viewModel.downloadSpeed)
                .opacity(viewModel.stateUI == .connected ? ([.wireGuard, .recommended].contains(NetworkManager.shared.selectConfig) ? 0 : 1) : 0)
                .frame(width: widthSpeed, height: Constant.Board.QuickButton.widthSize)
        }
    }
    
    func getConnectAlert() -> some View {
        AlertConnectView(flag: viewModel.flag, name: viewModel.nameSelect)
    }
    
    func getContentButton() -> some View {
        switch viewModel.stateUI {
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
                Text("STOP").foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 16, weight: .bold))
                    .padding()
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
        VStack(alignment: .trailing, spacing: 0) {
            Text("Connected")
                .foregroundColor(Color.gray)
                .font(.system(size: 14, weight: .bold))
                .lineLimit(1)
                .onAppear {
                    if self.stopWatch.isPaused() {
                        self.stopWatch.start()
                    }
                }
            Text(self.stopWatch.stopWatchTime)
                .foregroundColor(Color.white)
                .font(.system(size: 14, weight: .bold))
                .lineLimit(1)
                .onAppear {
                    if self.stopWatch.isPaused() {
                        self.stopWatch.start()
                    }
                }
        }
        .frame(width: Constant.Board.QuickButton.heightSize + 5,
               height: Constant.Board.QuickButton.heightSize + 5)

    }
}
