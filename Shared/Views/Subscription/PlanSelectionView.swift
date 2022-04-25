//
//  PlanSelectionView.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 13/01/2022.
//

import Foundation
import SwiftUI

struct PlanSelectionView: View {
    @EnvironmentObject var registerResult: RegisterResultModel
    @ObservedObject var planListViewModel = PlanListViewModel()
    @State var toWelcomeScreen = false
    var body: some View {
        Background {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Group {
                        Spacer().frame(height: 100)
                        Text(L10n.PlanSelect.title).setTitle()
                        Spacer().frame(height: 10)
                        Text(L10n.PlanSelect.body).setDefault()
                    }
                    Group {
                        Spacer().frame(height: 20)
                        PlanListView(viewModel: planListViewModel)
                        Spacer().frame(height: 20)
                    }
                    NavigationLink(destination: WelcomeView().environmentObject(registerResult), isActive: $toWelcomeScreen) {
                    }
                    AppButton(width: 311, text: L10n.PlanSelect.continueButton) {
                        self.toWelcomeScreen = true
                    }
                    Spacer().frame(height: 20)
                    Text(planListViewModel.selectedPlan?.note ?? "")
                        .font(.system(size: 11))
                        .foregroundColor(Color.white)
                        .frame(width: 320)
                    Spacer().frame(height: 20)
                }
            }
        }
    }
}

#if DEBUG
struct PlanSelectionView_Preview: PreviewProvider {
    static var previews: some View {
        PlanSelectionView()
    }
}
#endif
