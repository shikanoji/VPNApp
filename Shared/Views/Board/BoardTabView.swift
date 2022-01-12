//
//  BoardTabView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 23/12/2021.
//

import SwiftUI

struct BoardTabView: View {
    @Binding var tab: BoardViewModel.StateTab
    
    var body: some View {
        return HStack(spacing: 0) {
            BoardTabViewCustom(title: LocalizedStringKey.Board.locationTab.localized,
                               typeTab: .location, currentTab: $tab)
            BoardTabViewCustom(title: LocalizedStringKey.Board.staticIPTab.localized,
                               typeTab: .staticIP, currentTab: $tab)
            BoardTabViewCustom(title: LocalizedStringKey.Board.multiHopTab.localized,
                               typeTab: .multiHop, currentTab: $tab)
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
    @Binding var currentTab: BoardViewModel.StateTab
    
    var typeTab: BoardViewModel.StateTab
    var title: String
    
    init(title: String, typeTab: BoardViewModel.StateTab, currentTab: Binding<BoardViewModel.StateTab>) {
        self.title = title
        self.typeTab = typeTab
        self._currentTab = currentTab
        self._selected = Binding<Bool>.constant(currentTab.wrappedValue == typeTab)
    }
    
    var body: some View {
        Button(title) {
            if !selected {
                selected = true
                currentTab = typeTab
            }
        }
        .font(Font.system(size: 13, weight: .semibold))
        .padding()
        .frame(height: Constant.Board.Tabs.heightSize)
        .frame(maxWidth: .infinity)
        .background(selected ? AppColor.backgroundStatusView : AppColor.darkButton)
        .cornerRadius(Constant.Board.SubBoard.radius)
    }
}

struct BoardTabView_Previews: PreviewProvider {
    static var previews: some View {
        BoardTabView(tab: Binding<BoardViewModel.StateTab>.constant(.staticIP))
            .previewLayout(.fixed(width: 343.0, height: Constant.Board.Tabs.heightSize))
    }
}
