//
//  BoardTabView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 23/12/2021.
//

import SwiftUI

struct BoardTabView: View {
    @Binding var tab: StateTab
    @Binding var showBoardList: Bool
    
    var body: some View {
        return HStack(spacing: 0) {
            BoardTabViewCustom(typeTab: .location, currentTab: $tab, showBoardList: $showBoardList)
            BoardTabViewCustom(typeTab: .staticIP, currentTab: $tab, showBoardList: $showBoardList)
            BoardTabViewCustom(typeTab: .multiHop, currentTab: $tab, showBoardList: $showBoardList)
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(Color.white)
        .background(AppColor.darkButton)
        .frame(height: Constant.Board.Tabs.heightSize)
        .cornerRadius(Constant.Board.SubBoard.radius)
    }
}

struct BoardTabViewCustom: View {
    @Binding private var selected: Bool
    @Binding var currentTab: StateTab
    @Binding var showBoardList: Bool
    
    var typeTab: StateTab
    var title: String
    
    init(typeTab: StateTab, currentTab: Binding<StateTab>, showBoardList: Binding<Bool>) {
        switch typeTab {
        case .location:
            self.title = L10n.Board.locationTitleTab
        case .staticIP:
            self.title = L10n.Board.staticIPTitleTab
        case .multiHop:
            self.title = L10n.Board.multiHopTitleTab
        }
        
        self.typeTab = typeTab
        self._currentTab = currentTab
        self._selected = Binding<Bool>.constant(currentTab.wrappedValue == typeTab)
        self._showBoardList = showBoardList
    }
    
    var body: some View {
        Button(title) {
            if !selected {
                selected = true
                currentTab = typeTab
            }
            showBoardList = true
        }
        .buttonStyle(PrimaryButtonStyle(backgroundColor: selected ? AppColor.backgroundStatusView : AppColor.darkButton, cornerRadius: Constant.Board.SubBoard.radius))
    }
}

struct BoardTabView_Previews: PreviewProvider {
    @State static var show = false
    
    static var previews: some View {
        BoardTabView(tab: Binding<StateTab>.constant(.staticIP), showBoardList: $show)
            .previewLayout(.fixed(width: 343.0, height: Constant.Board.Tabs.heightSize))
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
