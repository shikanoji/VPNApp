//
//  Introduction.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 07/12/2021.
//

import Foundation
import SwiftUI

struct IntroductionView: View {
    @State var index = 0

    var images = ["Introduction-1", "Introduction-2"]
    
    var body: some View {
        VStack(spacing: 20) {
                    PagingView(index: $index.animation(), maxIndex: images.count - 1) {
                        ForEach(self.images, id: \.self) { imageName in
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                        }
                    }
                    .aspectRatio(3/4, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 15))

                    Stepper("Index: \(index)", value: $index.animation(.easeInOut), in: 0...images.count-1)
                        .font(Font.body.monospacedDigit())
                }
                .padding()
    }
}

struct IntroductionView_Preview: PreviewProvider {
    static var previews: some View {
        IntroductionView()
    }
}
