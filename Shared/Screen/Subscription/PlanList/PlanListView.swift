//
//  PlanListView.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 17/01/2022.
//

import Foundation
import SwiftUI

struct PlanListView: View {
    @StateObject var viewModel: PlanListViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(Plan.getListPlan(), id: \.self) { item in
                PlanListCell(
                    focus: (viewModel.selectedPlan?.name ?? "") == item.name,
                    plan: item)
                .onTapGesture {
                    viewModel.selectPlan(plan: item)
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
        PlanListView(viewModel: PlanListViewModel())
    }
}
#endif
