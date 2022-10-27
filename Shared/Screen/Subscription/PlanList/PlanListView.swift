//
//  PlanListView.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 17/01/2022.
//

import Foundation
import SwiftUI

struct PlanListView: View {
    @Binding var selectedPlan: Plan?

    var changePlan = false

    var body: some View {
        VStack(spacing: 16) {
            ForEach(Plan.getListPlan(), id: \.self) { item in
                PlanListCell(
                    focus: (selectedPlan?.name ?? "") == item.name,
                    plan: item,
                    changePlan: changePlan)
                    .onTapGesture {
                        selectedPlan = item
                    }
            }
        }
        .background(Color.clear)
        .padding(.bottom, 20)
    }
}

#if DEBUG
struct PlanListView_Preview: PreviewProvider {
    static var previews: some View {
        PlanListView(selectedPlan: .constant(Plan.planA))
    }
}
#endif
