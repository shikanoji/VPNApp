//
//  PlanSelectionViewModel.swift
//  SysVPN (iOS)
//
//  Created by Nguyen Dinh Thach on 17/06/2022.
//

import Foundation
import StoreKit
import SwiftUI

class PlanSelectionViewModel: ObservableObject {
    let productIDs = ["sysvpn.subscription.1year", "sysvpn.subscription.6months", "sysvpn.subscription.1month"]
    @ObservedObject var planListViewModel: PlanListViewModel
    @Published var planList: [SKProduct]
    @Published var toWelcomeScreen = false
    @Published var showProgressView = false
    init() {
        planList = []
        planListViewModel = PlanListViewModel()
    }
    func loadPlans() {
        IAPHandler.shared.setProductIds(ids: productIDs)
        IAPHandler.shared.fetchAvailableProducts { [weak self] products in
            guard let strongSelf = self else { return }
            strongSelf.planList = products
        }
    }
    
    @MainActor func purchasePlan() {
        showProgressView = true
        guard let selectedPlan = planListViewModel.selectedPlan else { return }
        var product: SKProduct?
        for plan in planList {
            if plan.productIdentifier == selectedPlan.subscriptionID {
                product = plan
                break
            }
        }
        guard let plan = product else {
            showProgressView = false
            return
        }
        IAPHandler.shared.purchase(product: plan) { [weak self] alert, skProduct, payment in
            self?.showProgressView = false
            if alert == .purchased {
                if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
                    FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {

                    do {
                        let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                        
                        let receiptString = receiptData.base64EncodedString(options: [])
                        
                        // Read receiptData
                        self?.toWelcomeScreen = true
                    }
                    catch { print("Couldn't read receipt data with error: " + error.localizedDescription) }
                }
            }
        }
    }
}
