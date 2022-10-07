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
    var changePlan = false
    
    let widthContent = Constant.SizeButton.widthButtonFull
    
    var body: some View {
        VStack {
            HStack {
                Spacer().frame(width: 20)
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(plan.name)
                            .font(.system(size: Constant.TextSize.PlanListCell.name, weight: .semibold))
                            .foregroundColor(AppColor.themeColor)
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
                    .padding(.top, 18)
                    
                    HStack(alignment: .center) {
                        Text(plan.price)
                            .font(.system(size: Constant.TextSize.PlanListCell.price, weight: .semibold))
                            .foregroundColor(Color.white)
                        Text("/" + L10n.PlanSelect.month)
                            .font(.system(size: Constant.TextSize.PlanListCell.description))
                            .foregroundColor(Color.gray)
                    }
                    
                    Text(plan.description)
                        .font(.system(size: Constant.TextSize.PlanListCell.description))
                        .foregroundColor(Color.white).lineSpacing(5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if focus && !changePlan {
                        HStack {
                            Button(action : {
                                NotificationCenter.default.post(name: Constant.NameNotification.showIntroPlan, object: nil)
                            }) {
                                HStack {
                                    Spacer().frame(width: 10)
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(L10n.PlanSelect.dayFreeTrial)
                                            .font(.system(size: Constant.TextSize.PlanListCell.name, weight: .medium))
                                            .foregroundColor(AppColor.leftCircle)
                                        Text(L10n.PlanSelect.dayFreeTrialSub)
                                            .font(.system(size: Constant.TextSize.Global.description))
                                            .foregroundColor(AppColor.leftCircle)
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    Spacer()
                                    Asset.Assets.buttonNext.swiftUIImage
                                        .resizable()
                                        .frame(width: Constant.SizeImage.widthButton,
                                               height: Constant.SizeImage.heightButton)
                                }
                            }
                            .padding(.trailing, 20)
                            .frame(maxWidth: .infinity)
                            .background(AppColor.freeTrial)
                            .cornerRadius(35)
                            Spacer().frame(width: 20)
                        }
                    }
                }
            }
            Spacer().frame(height: 20)
        }
        .frame(width: widthContent)
        .background(AppColor.blackText)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(focus ? AppColor.themeColor : AppColor.darkButton, lineWidth: 2)
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
