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
    
    var widthConent: CGFloat = 311
    
    var body: some View {
        VStack {
            ForEach(Plan.getListPlan(), id: \.self) { item in
                PlanListCell(focus: (viewModel.selectedPlan?.name ?? "") == item.name, plan: item, widthConent: widthConent).onTapGesture {
                    viewModel.selectPlan(plan: item)
                }
            }
        }.background(Color.clear)
    }
}

#if DEBUG
struct PlanListView_Preview: PreviewProvider {
    static var previews: some View {
        PlanListView(viewModel: PlanListViewModel())
    }
}
#endif
