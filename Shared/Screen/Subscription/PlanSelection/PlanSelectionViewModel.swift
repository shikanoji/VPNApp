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
    
    @Published var planList: [SKProduct]
    @Published var toWelcomeScreen = false
    @Published var showProgressView = false
    @Published var shouldShowAccountLimitedView = false
    @Published var showAlert = false
    @Published var showIntroPlanListView = false
    
    @Published var selectPlan: Plan?
    @Published var selectedPlan: Plan?
    
    var shouldAllowLogout: Bool
    var authentication: Authentication?
    var alertMessage: String = ""
    let disposedBag = DisposeBag()
    init(shouldAllowLogout: Bool = false) {
        planList = []
        self.shouldAllowLogout = shouldAllowLogout
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showIntroPlan),
            name: Constant.NameNotification.showIntroPlan,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(startFree7DayTrial),
            name: Constant.NameNotification.startFree7DayTrial,
            object: nil
        )
    }
    
    @MainActor @objc private func startFree7DayTrial() {
#if DEBUG
        toWelcomeScreen = true
#else
        purchasePlan()
#endif
    }
    
    @objc private func showIntroPlan() {
        showIntroPlanListView = true
    }
    
    func loadPlans() {
        IAPHandler.shared.setProductIds(ids: productIDs)
        IAPHandler.shared.fetchAvailableProducts { [weak self] products in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.planList = products
            }
        }
    }
    
    @MainActor func purchasePlan() {
        showProgressView = true
        guard let selectedPlan = selectedPlan else {
            showProgressView = false
            return
        }
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
            }
        }
    }
    
    @MainActor func verifyReceipt() async {
        let verifyResult = await AppstoreReceiptHelper.shared.verifyReceipt()
        switch verifyResult {
        case .success(let response):
            showProgressView = false
            if response.success, let user = response.result, shouldAllowLogout {
                authentication?.upgradeToPremium(user: user)
                toWelcomeScreen = true
            } else {
                shouldShowAccountLimitedView = true
            }
        case .failure(let error):
            if let errorAPI = error as? APIError {
                alertMessage = errorAPI.description
                showAlert = true
            }
            showProgressView = false
        }
    }
}
