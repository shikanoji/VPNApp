//
//  AutoConnectView.swift
//  SysVPN
//
//  Created by Da Phan Van on 19/01/2022.
//

import SwiftUI

struct AutoConnectView: View {
    @Binding var showSettings: Bool
    @State var statusConnect: BoardViewModel.StateBoard = .connected
    
    @State var sectionList: [SectionType] = [.typeAutoConnect, .autoConnect]
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
                VStack() {
                    AppColor.darkButton
                        .frame(height: 10)
                    CustomNavigationView(
                        leftTitle: L10n.Settings.itemVPN,
                        currentTitle: L10n.Settings.itemAuto,
                        tapLeftButton: {
                            presentationMode.wrappedValue.dismiss()
                        }, tapRightButton: {
                            showSettings = false
                        }, statusConnect: statusConnect)
                    VStack(alignment: .leading, spacing: 1) {
                        ForEach(sectionList.indices) { i in
                            if sectionList[i].title != "" {
                                Text(sectionList[i].title)
                                    .padding(.vertical)
                                    .foregroundColor(AppColor.lightBlackText)
                                    .font(Font.system(size: 12))
                            }
                            ForEach(sectionList[i].items.indices) { j in
                                ItemRowCell(title: sectionList[i].items[j].type.title,
                                            content: sectionList[i].items[j].type.content,
                                            showRightButton: sectionList[i].items[j].type.showRightButton,
                                            showSwitch: sectionList[i].items[j].type.showSwitch,
                                            showSelect: sectionList[i].items[j].type.showSelect,
                                            position: sectionList[i].items.getPosition(j))
                            }
                        }
                    }
                    .padding(Constant.Menu.hozitalPaddingCell)
                    .padding(.top, Constant.Menu.topPaddingCell)
            }
        }
        .navigationBarHidden(true)
        .background(AppColor.background)
        .ignoresSafeArea()
    }
}
struct AutoConnectView_Previews: PreviewProvider {
    @State static var show = true
    
    static var previews: some View {
        AutoConnectView(showSettings: $show)
    }
}
