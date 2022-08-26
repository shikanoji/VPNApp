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
    @Binding var showAutoConnectDestinationView: Bool
    let imageSize: CGFloat = Constant.BoardList.heightImageNode
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
                .frame(height: 40)
            Button(action: {
                if showAutoConnectDestinationView {
                    showAutoConnectDestinationView = false
                } else {
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                HStack {
                    Image(Constant.CustomNavigation.iconLeft)
                    ImageView(withURL: $node.flag.wrappedValue, size: imageSize)
                        .clipShape(Circle())
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
                            nodeSelect = city
                            if showAutoConnectDestinationView {
                                showAutoConnectDestinationView = false
                            } else {
//                                presentationMode.wrappedValue.dismiss()
                            }
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
        CityListView(nodeSelect: $nodeSelect, node: node, showAutoConnectDestinationView: .constant(false))
    }
}
