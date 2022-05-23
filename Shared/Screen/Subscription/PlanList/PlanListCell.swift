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
    var body: some View {
        VStack {
            HStack {
                Spacer().frame(width: 20)
                VStack(alignment: .leading) {
                    Text(plan.name).font(.system(size: 16, weight: .semibold))
                        .foregroundColor(focus ? AppColor.themeColor : Color.white)
                    Spacer().frame(height: 10)
                    Text(plan.description).font(.system(size: 12)).foregroundColor(Color.white).lineSpacing(5)
                }.frame(width: 156)
                Spacer()
                VStack {
                    Text(plan.price).font(.system(size: 24, weight: .semibold))
                        .foregroundColor(focus ? AppColor.blackText : Color.white)
                    Spacer().frame(height: 5)
                    HStack() {
                        Spacer()
                        Text("/ " + L10n.PlanSelect.month).font(.system(size: 12)).foregroundColor(focus ? AppColor.blackText : Color.white)
                        Spacer().frame(width : 25)
                    }
                    Spacer().frame(height: 20)
                    if !plan.savingText.isEmpty {
                        VStack{
                            Text(plan.savingText + "%").foregroundColor(focus ? Color.white : AppColor.blackText).font(.system(size: 11, weight: .semibold))
                        }.frame(width: 93, height: 20)
                            .background(focus ? AppColor.background : Color.white)
                            .cornerRadius(10)
                    }
                }
                .frame(width: 116, height: 120)
                .background(focus ? AppColor.themeColor : Asset.Colors.planListCellDeactiveBackground.SuColor)
                .cornerRadius(15)
                Spacer().frame(width: 0)
            }
        }
        .frame(width: 311, height: 120)
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
