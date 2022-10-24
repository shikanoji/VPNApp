//
//  PlanListViewModel.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 17/01/2022.
//

import Foundation

struct Plan: Identifiable, Hashable {
    var id = UUID()
    var subscriptionID: String
    var name: String
    var description: String
    var price: String
    var savingText: String
    var note: String
    var noteTrial: String
    var get: String
    
    static let planA = Plan(subscriptionID: "sysvpn.ios.client.subscription.1year", name: L10n.PlanSelect.PlanA.title, description: L10n.PlanSelect.PlanA.description, price: L10n.PlanSelect.PlanA.price, savingText: L10n.PlanSelect.PlanA.savingText, note: L10n.PlanSelect.PlanA.note, noteTrial: L10n.PlanSelect.PlanA.noteTrial, get: L10n.PlanSelect.PlanA.get)
    
    static let planB = Plan(subscriptionID: "sysvpn.ios.client.subscription.6month", name: L10n.PlanSelect.PlanB.title, description: L10n.PlanSelect.PlanB.description, price: L10n.PlanSelect.PlanB.price, savingText: L10n.PlanSelect.PlanB.savingText, note: L10n.PlanSelect.PlanB.note, noteTrial: L10n.PlanSelect.PlanB.noteTrial, get: L10n.PlanSelect.PlanB.get)
    
    static let planC = Plan(subscriptionID: "sysvpn.ios.client.subscription.1month", name: L10n.PlanSelect.PlanC.title, description: L10n.PlanSelect.PlanC.description, price: L10n.PlanSelect.PlanC.price, savingText: L10n.PlanSelect.PlanC.savingText, note: L10n.PlanSelect.PlanC.note, noteTrial: L10n.PlanSelect.PlanC.noteTrial, get: L10n.PlanSelect.PlanC.get)
    
    static func getListPlan() -> [Plan] {
        return [planA, planB, planC]
    }
}
