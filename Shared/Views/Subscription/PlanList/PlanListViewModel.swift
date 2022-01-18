//
//  PlanListViewModel.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 17/01/2022.
//

import Foundation

struct Plan: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var description: String
    var price: String
    var savingText: String
    var note: String
    static func getListPlan() -> [Plan] {
        let planA = Plan(name: LocalizedStringKey.PlanSelect.planATitle.localized, description: LocalizedStringKey.PlanSelect.planADescription.localized, price: LocalizedStringKey.PlanSelect.planAPrice.localized, savingText: LocalizedStringKey.PlanSelect.planASavingText.localized, note: LocalizedStringKey.PlanSelect.planANote.localized)
        let planB = Plan(name: LocalizedStringKey.PlanSelect.planBTitle.localized, description: LocalizedStringKey.PlanSelect.planBDescription.localized, price: LocalizedStringKey.PlanSelect.planBPrice.localized, savingText: LocalizedStringKey.PlanSelect.planBSavingText.localized, note: LocalizedStringKey.PlanSelect.planBNote.localized)
        let planC = Plan(name: LocalizedStringKey.PlanSelect.planCTitle.localized, description: LocalizedStringKey.PlanSelect.planCDescription.localized, price: LocalizedStringKey.PlanSelect.planCPrice.localized, savingText: LocalizedStringKey.PlanSelect.planCSavingText.localized, note: LocalizedStringKey.PlanSelect.planCNote.localized)
        return [planA, planB, planC]
    }
}

class PlanListViewModel: ObservableObject {
    @Published var selectedPlan: Plan?
    
    func selectPlan(plan: Plan) {
        self.selectedPlan = plan
    }
}
