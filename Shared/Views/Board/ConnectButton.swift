//
//  ConnectButton.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 22/12/2021.
//

import SwiftUI
import Combine

struct ConnectButton: View {
    var status: BoardViewModel.StateBoard
    var uploadSpeed: CGFloat
    var downloadSpeed: CGFloat
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            Spacer()
            VStack(spacing: 10) {
                getConnectAlert()
                    .opacity(status == .connected ? 1 : 0)
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
            .frame(width:  Constant.Board.QuickButton.widthSize,
                   height: Constant.Board.QuickButton.widthSize)
            SpeedConnectedView(uploadSpeed: uploadSpeed, downLoadSpeed: downloadSpeed)
                .opacity(status == .connected ? 1 : 0)
                .padding(.top, 35)
        }
        .padding(.leading)
    }
    
    func getConnectAlert() -> some View {
        AlertConnectView()
    }
    
    func getContentButton() -> some View {
        switch status {
        case .notConnect:
            return AnyView(Text(LocalizedStringKey.Board.unconnectButton.localized)
                            .foregroundColor(Color.black)
                            .multilineTextAlignment(.center)
                            .font(.system(size: 14, weight: .bold))
                            .padding())
        case .loading:
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
            .modifier(AnimatingMoveDoc(yOffSet: change ? 5 : -5))
            .foregroundColor(Color.black)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + timeWait) {
                    withAnimation(.linear(duration: 0.5).repeatForever()) {
                        self.change.toggle()
                    }
                }
            }
    }
}

struct TimeConnectedView: View {
    @ObservedObject var stopWatch = StopWatch()
    
    var body: some View {
        Text(self.stopWatch.stopWatchTime)
            .truncationMode(.middle)
            .foregroundColor(Color.black)
            .font(.system(size: 14, weight: .bold))
            .lineLimit(1)
            .padding()
            .frame(width: Constant.Board.QuickButton.heightSize + 5,
                   height: Constant.Board.QuickButton.heightSize + 5)
            .padding()
            .onAppear {
                self.stopWatch.start()
            }
    }
}

struct AnimatingMoveDoc: AnimatableModifier {
    var yOffSet: CGFloat = 0
    
    var animatableData: CGFloat {
        get { yOffSet }
        set { yOffSet = newValue }
    }
    
    func body(content: Content) -> some View {
        content.offset(y: yOffSet)
    }
}

struct ConnectButton_Previews: PreviewProvider {
    static var previews: some View {
        ConnectButton(status: .connected, uploadSpeed: 100, downloadSpeed: 900)
            .preferredColorScheme(.dark)
    }
}