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
        let planA = Plan(name: L10n.PlanSelect.PlanA.title, description: L10n.PlanSelect.PlanA.description, price: L10n.PlanSelect.PlanA.price, savingText: L10n.PlanSelect.PlanA.savingText, note: L10n.PlanSelect.PlanA.note)
        let planB = Plan(name: L10n.PlanSelect.PlanB.title, description: L10n.PlanSelect.PlanB.description, price: L10n.PlanSelect.PlanB.price, savingText: L10n.PlanSelect.PlanB.savingText, note: L10n.PlanSelect.PlanB.note)
        let planC = Plan(name: L10n.PlanSelect.PlanC.title, description: L10n.PlanSelect.PlanC.description, price: L10n.PlanSelect.PlanC.price, savingText: L10n.PlanSelect.PlanC.savingText, note: L10n.PlanSelect.PlanC.note)
        return [planA, planB, planC]
    }
}

class PlanListViewModel: ObservableObject {
    @Published var selectedPlan: Plan?
    
    func selectPlan(plan: Plan) {
        self.selectedPlan = plan
    }
}
