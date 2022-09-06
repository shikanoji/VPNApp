//
//  FAQCell.swift
//  SysVPN
//
//  Created by Nguyễn Đình Thạch on 09/02/2022.
//

import Foundation
import SwiftUI

struct FAQCell: View {
    @State var question: QuestionModel
    @State var position: PositionItemCell = .middle
    
    var body: some View {
        HStack {
            Text(question.title)
                .font(Constant.Menu.fontItem)
                .foregroundColor(.white)
                .padding(.leading, 16.0)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(10)
            Spacer()
            Image(Constant.Account.rightButton)
                .padding()
        }
        .padding(.vertical, 10)
        .background(AppColor.darkButton)
        .cornerRadius(radius: Constant.Menu.radiusCell, corners: [position.rectCorner])
    }
}
