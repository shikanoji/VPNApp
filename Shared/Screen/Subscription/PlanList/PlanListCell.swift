//
//  PlanListCell.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 17/01/2022.
//

import Foundation
import SwiftUI

struct PlanListCell: View {
    var focus: Bool
    var plan: Plan
    var widthConent: CGFloat = 311
    
    var body: some View {
        VStack {
            HStack {
                Spacer().frame(width: 20)
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(plan.name)
                            .font(.system(size: Constant.TextSize.PlanListCell.name, weight: .semibold))
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        if !plan.savingText.isEmpty {
                            VStack{
                                Text(plan.savingText + "%")
                                    .foregroundColor( AppColor.blackText)
                                    .font(.system(size: Constant.TextSize.PlanListCell.savingText, weight: .semibold))
                            }
                            .padding(8)
                            .background(focus ? AppColor.planSelectSave : Color.white)
                            .clipShape(Capsule())
                        }
                        Spacer().frame(width: 20)
                    }
                    
                    HStack {
                        Text(plan.price)
                            .font(.system(size: Constant.TextSize.PlanListCell.price, weight: .semibold))
                            .foregroundColor(AppColor.themeColor)
                        Text(" /" + L10n.PlanSelect.month)
                            .font(.system(size: Constant.TextSize.PlanListCell.description))
                            .foregroundColor(Color.gray)
                    }
                    
                    Text(plan.description)
                        .font(.system(size: Constant.TextSize.PlanListCell.description))
                        .foregroundColor(Color.white).lineSpacing(5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .frame(width: widthConent, height: 120)
        .background(AppColor.darkButton)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(focus ? AppColor.themeColor : Color.clear, lineWidth: 2)
        )
        
    }
}

#if DEBUG
struct PlanListCell_Preview: PreviewProvider {
    static var previews: some View {
        PlanListCell(focus: true, plan: Plan.getListPlan().first!)
    }
}
#endif
