//
//  SearchBar.swift
//  SysVPN
//
//  Created by Da Phan Van on 20/01/2022.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    
    @Binding var isEditing: Bool
    
    var body: some View {
        HStack {
            TextField("", text: $text)
                .placeholder(when: text.isEmpty) {
                    Text("Search").foregroundColor(AppColor.lightBlackText)
                }
                .padding(EdgeInsets(top: 0,
                                    leading: 50,
                                    bottom: 0,
                                    trailing: 25))
                .background(Color.clear)
                .frame(height: Constant.BoardList.heightSearchLoction)
                .overlay(
                    RoundedRectangle(cornerRadius: 30).stroke(AppColor.borderSearch)
                )
                .overlay(
                    HStack {
                        if !isEditing {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 20)
                        } else {
                            Image(Constant.CustomNavigation.iconLeft)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 20)
                                .onTapGesture {
                                    text = ""
                                    isEditing = false
                                }
                        }
                    }
                )
                .onTapGesture {
                    isEditing = true
                }
                .onChange(of: text, perform: { newValue in
                    isEditing = text != ""
                })
                .foregroundColor(.white)
                .font(.system(size: 14))
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    @State static var isEditing = true
    @State static var txt = ""
    
    static var previews: some View {
        SearchBar(text: $txt, isEditing: $isEditing)
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/365.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/))
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}
