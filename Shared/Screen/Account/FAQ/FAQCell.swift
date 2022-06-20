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
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(question.title)
                        .font(Constant.Menu.fontItem)
                        .foregroundColor(.white)
                }
            }
            .padding(.leading, 16.0)
            Spacer()
            Image(Constant.Account.rightButton)
                .padding()
        }
        .frame(height: Constant.Menu.heightItemCell)
        .frame(maxWidth: .infinity)
        .background(AppColor.darkButton)
        .cornerRadius(radius: Constant.Menu.radiusCell, corners: [position.rectCorner])
    }
}
