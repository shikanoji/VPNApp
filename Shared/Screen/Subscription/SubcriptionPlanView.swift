//
//  SubcriptionPlanView.swift
//  SysVPN
//
//  Created by Da Phan Van on 01/10/2022.
//

import SwiftUI

struct SubcriptionPlanView: View {
    let plan: Plan?
    
    let widthConent = Constant.SizeButton.widthButtonFull
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    func textHeader(_ text: String) -> Text {
        Text(text)
            .font(.system(size: Constant.TextSize.PlanListCell.header, weight: .semibold))
            .foregroundColor(Color.white)
    }
    
    func textBody(_ text: String) -> some View {
        Text(text)
            .font(.system(size: Constant.TextSize.PlanListCell.body, weight: .medium))
            .foregroundColor(Color.white).lineSpacing(5)
            .multilineTextAlignment(.center)
    }
    
    func arrowIcon() -> some View {
        Asset.Assets.arrowDown.swiftUIImage
            .frame(width: 64, height: 24)
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 30) {
                CustomSimpleNavigationView(title: "", backgroundColor: .clear)
                Text(L10n.PlanSelect.headerSubcription)
                    .font(.system(size: Constant.TextSize.PlanListCell.titleSubcription, weight: .bold))
                    .foregroundColor(Color.white)
                VStack(spacing: 30) {
                    VStack(alignment: .center, spacing: 12) {
                        textHeader(L10n.PlanSelect.header1)
                        textBody(L10n.PlanSelect.content1)
                        arrowIcon()
                    }
                    
                    VStack(alignment: .center, spacing: 12) {
                        textHeader(L10n.PlanSelect.header2)
                        textBody(L10n.PlanSelect.content2)
                        arrowIcon()
                    }
                    
                    VStack(alignment: .center, spacing: 12) {
                        textHeader(L10n.PlanSelect.header3)
                        textBody(L10n.PlanSelect.content3)
                        arrowIcon()
                    }
                    
                    Text(plan?.description ?? "")
                        .font(.system(size: Constant.TextSize.PlanListCell.description))
                        .foregroundColor(Color.white)
                }
                
                Spacer()
                
                VStack(spacing: 16) {
                    AppButton(width: widthConent, text: L10n.Introduction.trialButton) {
                        NotificationCenter.default.post(name: Constant.NameNotification.startFree7DayTrial, object: nil)
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                    AppButton(style: .darkButton, width: widthConent, text: L10n.PlanSelect.seeAllPlan) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                Spacer().frame(minHeight: 20)
            }
        }
        .background(AppColor.blackText)
        .ignoresSafeArea()
    }
}
