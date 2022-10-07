//
//  CityListView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 08/02/2022.
//

import SwiftUI

struct CityListView: View {
    @Binding var nodeSelect: Node?
    @State var node: Node
    
    let imageSize: CGFloat = Constant.BoardList.heightImageNode
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack(spacing: 8) {
            Button(action: {
                    presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(Constant.CustomNavigation.iconLeft)
                    Group {
                        if let url = URL(string: node.flag) {
                            AsyncImage(
                                url: url,
                                placeholder: {
                                    Asset.Assets.flagDefault.swiftUIImage
                                        .resizable()
                                },
                                image: { Image(uiImage: $0).resizable() })
                        } else {
                            Asset.Assets.flagDefault.swiftUIImage
                        }
                    }
                        .clipShape(Circle())
                        .frame(width: imageSize, height: imageSize)
                    Text(node.name)
                        .font(Constant.BoardList.fontNameCity)
                        .foregroundColor(.white)
                    Spacer()
                }
            }
            .padding()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    ForEach(node.cityNodeList) { city in
                        Button {
                            AppSetting.shared.temporaryDisableAutoConnect = false
                            nodeSelect = city
                        } label: {
                            CityCellView(node: city, subName: L10n.Board.BoardList.cityOf + " \(node.name)")
                        }
                    }
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarHidden(true)
        .background(AppColor.background)
        .ignoresSafeArea()
    }
}

struct CityListView_Previews: PreviewProvider {
    @State static var node: Node = Node.country
    @State static var nodeSelect: Node? = Node.country
    
    static var previews: some View {
        CityListView(nodeSelect: $nodeSelect, node: node)
    }
}
