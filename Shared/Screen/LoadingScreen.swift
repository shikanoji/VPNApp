//
//  LoadingScreen.swift
//  SysVPN (iOS)
//
//  Created by Nguyen Dinh Thach on 27/06/2022.
//

import Foundation
import SwiftUI

struct LoadingScreen<Content>: View where Content: View {

    @Binding var isShowing: Bool
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {

                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)

                LoadingView()
                .opacity(self.isShowing ? 1 : 0)
            }
        }
    }

}
