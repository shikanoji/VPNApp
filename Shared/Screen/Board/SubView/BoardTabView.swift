//
//  BoardTabView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 23/12/2021.
//

import SwiftUI

struct BoardTabView: View {
    @StateObject var viewModel: BoardViewModel

    var body: some View {
        ZStack {
            HStack(spacing: 5) {
                BoardTabViewCustom(typeTab: .location, viewModel: viewModel)
                BoardTabViewCustom(typeTab: .staticIP, viewModel: viewModel)
                BoardTabViewCustom(typeTab: .multiHop, viewModel: viewModel)
            }
            .cornerRadius(Constant.Board.SubBoard.radius)
            .padding(6)
        }
        .foregroundColor(Color.white)
        .background(AppColor.lightBlack)
        .frame(height: Constant.Board.Tabs.heightSize + 20)
        .frame(width: UIScreen.main.bounds.size.width - 40)
        .cornerRadius(Constant.Board.SubBoard.radius + 6)
    }
}

struct BoardTabViewCustom: View {

    var typeTab: StateTab
    @StateObject var viewModel: BoardViewModel

    var body: some View {
        Button(typeTab.title) {
            DispatchQueue.main.async {
                viewModel.selectedTab = typeTab
                viewModel.configShowBoardList(true)
            }
        }
        .buttonStyle(PrimaryButtonStyle(backgroundColor: viewModel.selectedTab == typeTab ? AppColor.darkButton : AppColor.lightBlack, cornerRadius: Constant.Board.SubBoard.radius))
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    var backgroundColor: Color = .black
    var textColor: Color = Color.white
    var height: CGFloat = 46
    var cornerRadius: CGFloat = 15
    var fontSize: CGFloat = 13
    var disabled: Bool = false
    var textSidePadding: CGFloat = 30
    var weight: Font.Weight = .semibold

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: height)
            .background(disabled ? .gray : backgroundColor)
            .foregroundColor(textColor)
            .cornerRadius(Constant.Board.SubBoard.radius)
            .font(.system(size: fontSize, weight: weight, design: .default))
            .lineLimit(1)
    }
}
