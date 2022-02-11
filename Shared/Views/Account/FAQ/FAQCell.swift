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
    var onTap: () -> Void
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(question.question)
                        .font(Constant.Menu.fontItem)
                        .foregroundColor(.white)
                }
            }
            .padding(.leading, 16.0)
            Spacer()
            Image(Constant.Account.rightButton)
                .padding()
                .onTapGesture {
                    
                }
        }
        .frame(height: Constant.Menu.heightItemCell)
        .frame(maxWidth: .infinity)
        .background(AppColor.darkButton)
        .cornerRadius(radius: Constant.Menu.radiusCell, corners: [position.rectCorner])
    }
}

#if DEBUG
struct FAQCell_Preview: PreviewProvider {
    static var previews: some View {
        FAQCell(question: QuestionModel(id: "AC", question: "Will I be notified if my subscription is terminated?", answer: "AAAAAAAAAAAAA"), position: .top, onTap: {
            
        })
    }
}
#endif
