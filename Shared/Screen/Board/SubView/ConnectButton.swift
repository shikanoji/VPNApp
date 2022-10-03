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
    
    var widthSizeFrame = UIScreen.main.bounds.width
    var heightSizeFrame = UIScreen.main.bounds.height
    
    var tapButton: (() -> Void)? = nil
    
    func calculatebuttonsizeWidth(widthSizeFrame: CGFloat) -> CGFloat {
        if widthSizeFrame < 375 {
            return 350
        }
        else if widthSizeFrame > 768 {
            return 600
        }
        else {
            return UIScreen.main.bounds.width
        }
    }
    
    func calculatebuttonsizeHeight(heightSizeFrame: CGFloat) -> CGFloat {
        if heightSizeFrame < 667 {
            return 350
        }
        else if heightSizeFrame > 1024 {
            return 600
        }
        else {
            return UIScreen.main.bounds.height
        }
    }
    
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
                        .padding(.bottom, startAlertScroll ? 0 : 70)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                                startAlertScroll = true
                            })
                        }
                        .onDisappear {
                            startAlertScroll = false
                        }
                        .animation(Animation.easeInOut(duration: 0.3))
                        .frame(width: Constant.Board.QuickButton.widthSize * 2)
                        .opacity(!startAlertScroll ? 0 : 1)
                }
                ZStack {
                    Circle()
                        .strokeBorder(viewModel.stateUI == .disconnected ? Color.white : AppColor.themeColor, lineWidth: Constant.Board.QuickButton.widthBorderMax)
                        .frame(width: calculatebuttonsizeWidth(widthSizeFrame: widthSizeFrame)/4.5 + 21,
                               height: calculatebuttonsizeHeight(heightSizeFrame: heightSizeFrame)/4.5 + 21)
                        .background(Circle().foregroundColor(viewModel.stateUI == .disconnected ? AppColor.themeColor : Color.white))
                    Circle()
                        .strokeBorder(Color.black, lineWidth: Constant.Board.QuickButton.widthBorderMax)
                        .frame(width: calculatebuttonsizeWidth(widthSizeFrame: widthSizeFrame)/4.5 + 14,
                               height: calculatebuttonsizeHeight(heightSizeFrame: heightSizeFrame)/4.5 + 14)
                    getContentButton()
                }
                .frame(width: calculatebuttonsizeWidth(widthSizeFrame: widthSizeFrame)/4.5,
                       height: calculatebuttonsizeWidth(widthSizeFrame: widthSizeFrame)/4.5)
                .onTapGesture {
                    tapButton?()
                }
            }
            .frame(width:  Constant.Board.QuickButton.widthSize)
            SpeedConnectedView(uploadSpeed: viewModel.uploadSpeed, downLoadSpeed: viewModel.downloadSpeed)
                .opacity(viewModel.stateUI == .connected ? ([.openVPNTCP, .openVPNUDP].contains(NetworkManager.shared.getValueConfigProtocol) ? 1 : 0) : 0)
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
                            .font(.system(size: calculatebuttonsizeWidth(widthSizeFrame: widthSizeFrame) * 0.038, weight: .bold))
                            .padding())
        case .connecting, .disconnecting:
            return AnyView(getDocAnimation()
                            .padding())
        case .connected:
            return AnyView(
                Text("STOP").foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .font(.system(size: calculatebuttonsizeWidth(widthSizeFrame: widthSizeFrame) * 0.038, weight: .semibold))
                    .padding()
            )
        }
    }
    
    @State private var bouncing = false
    
    func getDocAnimation() -> some View {
        return HStack(spacing: 5) {
//            DocAnimationView(timeWait: 0.2)
//            DocAnimationView(timeWait: 0.4)
//            DocAnimationView(timeWait: 0.6)
            DocAnimationView1()
            DocAnimationView2()
            DocAnimationView3()
        }
    }
}

struct DocAnimationView1: View {
    @State private var change = false
    let imageChangeTimer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Circle()
            .frame(width: Constant.Board.QuickButton.sizeDoc,
                   height: Constant.Board.QuickButton.sizeDoc)
            .offset(y: change ? 5 : -5)
            .foregroundColor(Color.black)
            .onReceive(imageChangeTimer) { _ in
                change.toggle()
            }
            .animation(Animation.linear)
    }
}

struct DocAnimationView2: View {
    @State private var change = false
    let imageChangeTimer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Circle()
            .frame(width: Constant.Board.QuickButton.sizeDoc,
                   height: Constant.Board.QuickButton.sizeDoc)
            .offset(y: change ? 5 : -5)
            .foregroundColor(Color.black)
            .onReceive(imageChangeTimer) { _ in
                change.toggle()
            }
            .animation(Animation.linear.delay(0.2))
    }
}

struct DocAnimationView3: View {
    @State private var change = false
    let imageChangeTimer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Circle()
            .frame(width: Constant.Board.QuickButton.sizeDoc,
                   height: Constant.Board.QuickButton.sizeDoc)
            .offset(y: change ? 5 : -5)
            .foregroundColor(Color.black)
            .onReceive(imageChangeTimer) { _ in
                change.toggle()
            }
            .animation(Animation.linear.delay(0.4))
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
                DispatchQueue.main.async {
                    self.change.toggle()
                }
            }
            .animation(Animation.linear(duration: 0.5).repeatForever().delay(timeWait))
    }
}

struct TimeConnectedView: View {
    @StateObject var stopWatch = StopWatch()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("   " + "Session")
                .foregroundColor(Color.gray)
                .font(.system(size: Constant.TextSize.Global.detailDefault, weight: .bold))
                .lineLimit(1)
                .onAppear {
                    if self.stopWatch.isPaused() {
                        self.stopWatch.start()
                    }
                }
                .frame(width: 100, alignment: .leading)
            Text(self.stopWatch.stopWatchTime)
                .foregroundColor(Color.white)
                .font(.system(size: Constant.TextSize.Global.detailDefault, weight: .bold))
                .lineLimit(1)
                .onAppear {
                    if self.stopWatch.isPaused() {
                        self.stopWatch.start()
                    }
                }
                .frame(width: 100, alignment: .leading)
        }
        .frame(width: Constant.Board.QuickButton.heightSize,
               height: Constant.Board.QuickButton.heightSize)

    }
}
