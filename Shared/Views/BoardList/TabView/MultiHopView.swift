//
//  MultiHopView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 08/02/2022.
//

import SwiftUI

struct MultiHopView: View {
    
    let sizeIcon = Constant.MultiHop.sizeIcon
    
    @Binding var nodeRecentList: [(Node, Node)]
    
    @State var showDescriptionMultihop = false
    @State var showEntryLocationView = false
    @State var showExitLocationView = false
    
    @Binding var entryNodeList: [Node]
    @Binding var exitNodeList: [Node]
    
    @Binding var entryNodeSelect: Node
    @Binding var exitNodeSelect: Node
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button {
                showDescriptionMultihop = true
            } label: {
                HStack {
                    Constant.MultiHop.iconWhat
                    Text(LocalizedStringKey.MultiHop.whatIsMultiHop.localized)
                        .foregroundColor(.white)
                        .font(Constant.BoardList.fontNodeList)
                }
            }
            Spacer()
                .frame(height: 4)
            recentConnectionsView
            Rectangle()
                .foregroundColor(AppColor.darkButton)
                .frame(height: 1)
            selectView
            Group {
                Spacer()
                    .frame(height: 0)
                AppButton(style: .themeButton, width: UIScreen.main.bounds.size.width - 32, text: LocalizedStringKey.MultiHop.connect.localized) {
                    
                }
                Spacer()
                    .frame(height: 0)
                Button {
                    print("Connect")
                } label: {
                    HStack {
                        Constant.MultiHop.iconExit
                        Text(LocalizedStringKey.MultiHop.exit.localized)
                            .foregroundColor(.white)
                            .font(Constant.BoardList.fontNodeList)
                    }
                }
                Spacer()
            }
        }
        .padding()
        .frame(maxHeight: .infinity)
        .navigationBarHidden(true)
        .background(AppColor.background)
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $showDescriptionMultihop) {
            
        } content: {
            DescriptionMultihopView()
                .clearModalBackground()
        }
        NavigationLink(destination:
                        SelectLocationMultihopView(nodeList: $entryNodeList,
                                                   leftText: LocalizedStringKey.MultiHop.selectEntryLocation.localized, nodeSelectClosure: { self.entryNodeSelect = $0 }),
                       isActive: $showEntryLocationView) { }
        NavigationLink(destination: SelectLocationMultihopView(nodeList: $exitNodeList,
                                                               leftText: LocalizedStringKey.MultiHop.selectExitLocation.localized, nodeSelectClosure: { self.exitNodeSelect = $0 }),
                       isActive: $showExitLocationView) { }
    }
    
    var recentConnectionsView: some View {
        Group {
            Text(LocalizedStringKey.MultiHop.recentConnections.localized)
                .foregroundColor(AppColor.lightBlackText)
                .font(Constant.BoardList.fontNodeList)
            ForEach((0..<nodeRecentList.count), id: \.self) { i in
                let nodeStart = nodeRecentList[i].0
                let nodeEnd = nodeRecentList[i].1
                HStack {
                    ImageView(withURL: nodeStart.flag)
                        .frame(width: sizeIcon, height: sizeIcon)
                        .clipShape(Circle())
                    Text(nodeStart.name)
                        .foregroundColor(.white)
                        .font(Constant.BoardList.fontNodeList)
                    Spacer()
                    Constant.Global.iconArrowRight
                        .frame(width: 20, height: 20)
                    Spacer()
                    ImageView(withURL: nodeEnd.flag)
                        .frame(width: sizeIcon, height: sizeIcon)
                        .clipShape(Circle())
                    Text(nodeEnd.name)
                        .foregroundColor(.white)
                        .font(Constant.BoardList.fontNodeList)
                    Spacer()
                }
            }
        }
    }
    
    var selectView: some View {
        Group {
            Text(LocalizedStringKey.MultiHop.selectEntryLocation.localized)
                .foregroundColor(AppColor.lightBlackText)
                .font(Constant.BoardList.fontNodeList)
            
            Button {
                showEntryLocationView = true
            } label: {
                HStack {
                    ImageView(withURL: entryNodeSelect.flag)
                        .frame(width: sizeIcon, height: sizeIcon)
                        .clipShape(Circle())
                    Text(entryNodeSelect.name)
                        .foregroundColor(.white)
                        .font(Constant.BoardList.fontNodeList)
                    Spacer()
                    Image(Constant.Account.rightButton)
                }
            }
            
            Text(LocalizedStringKey.MultiHop.selectExitLocation.localized)
                .foregroundColor(AppColor.lightBlackText)
                .font(Constant.BoardList.fontNodeList)
            
            Button {
                showExitLocationView = true
            } label: {
                HStack {
                    ImageView(withURL: exitNodeSelect.flag)
                        .frame(width: sizeIcon, height: sizeIcon)
                        .clipShape(Circle())
                    Text(exitNodeSelect.name)
                        .foregroundColor(.white)
                        .font(Constant.BoardList.fontNodeList)
                    Spacer()
                    Image(Constant.Account.rightButton)
                }
            }
        }
    }
}

struct MultiHopView_Previews: PreviewProvider {
    @State static var nodeMultihopList = [(Node.country, Node.tokyo), (Node.country, Node.tokyo)]
    
    @State static var entryNode = Node.country
    @State static var exitNode = Node.tokyo
    @State static var nodeList = Node.all
    
    static var previews: some View {
        MultiHopView(nodeRecentList: $nodeMultihopList,
                     entryNodeList: $nodeList,
                     exitNodeList: $nodeList,
                     entryNodeSelect: $entryNode,
                     exitNodeSelect: $exitNode)
    }
}
