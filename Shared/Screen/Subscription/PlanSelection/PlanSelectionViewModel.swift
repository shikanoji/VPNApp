//
//  PlanSelectionViewModel.swift
//  SysVPN (iOS)
//
//  Created by Nguyen Dinh Thach on 17/06/2022.
//

import Foundation
import StoreKit
import SwiftUI
import RxSwift

class PlanSelectionViewModel: ObservableObject {
    let productIDs = ["sysvpn.ios.client.subscription.1year", "sysvpn.ios.client.subscription.6month", "sysvpn.ios.client.subscription.1month"]
    @ObservedObject var planListViewModel: PlanListViewModel
    @Published var planList: [SKProduct]
    @Published var toWelcomeScreen = false
    @Published var showProgressView = false
    @Published var shouldShowAccountLimitedView = false
    @Published var showAlert = false
    var shouldAllowLogout: Bool
    var authentication: Authentication?
    var alertMessage: String = ""
    let disposedBag = DisposeBag()
    init(shouldAllowLogout: Bool = false) {
        planList = []
        planListViewModel = PlanListViewModel()
        self.shouldAllowLogout = shouldAllowLogout
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
            switch alert {
            case .purchased:
                Task {
                    await self?.verifyReceipt()
                }
            default:
                self?.showProgressView = false
                self?.shouldShowAccountLimitedView = true
            }
        }
    }
    
    @MainActor func verifyReceipt() async {
        let verifyResult = await AppstoreReceiptHelper.shared.verifyReceipt()
        switch verifyResult {
        case .success(let response):
            showProgressView = false
            if response.success, let user = response.result, shouldAllowLogout{
                authentication?.upgradeToPremium(user: user)
                toWelcomeScreen = true
            } else {
                self.shouldShowAccountLimitedView = true
            }
        case .failure(let error):
            print(error)
            showProgressView = false
            alertMessage = "An error occured. Please try again!"
            showAlert = true
        }
    }
}
