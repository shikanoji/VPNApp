//
//  DeviceViewModel.swift
//  SysVPN
//
//  Created by Nguyễn Đình Thạch on 08/02/2022.
//

import Foundation
import RxSwift
import SwiftUI

class SessionVPNViewModel: ObservableObject {
    @Published var deviceList: [SessionVPN] = []
    @Published var showAlert: Bool = false
    @Published var showProgressView: Bool = false
    @Published var showSessionTerminatedAlert: Bool = false
    @Published var currentNumberDevice: String = "\(AppSetting.shared.currentNumberDevice)"
    @Published var showPopupView: Bool = false
    @Published var disconnectCurrentSession: Bool = false
    var sessionSelect: SessionVPN?

    var error: APIError?
    var limit = AppSetting.shared.maxNumberDevices

    let disposedBag = DisposeBag()

    init() {}

    func getListSession() {
        showProgressView = true

        ServiceManager.shared.getListSession()
            .subscribe(onSuccess: { [weak self] response in
                self?.showProgressView = false
                guard let strongSelf = self else {
                    return
                }
                if let result = response.result {
                    strongSelf.deviceList = result.rows
                    strongSelf.currentNumberDevice = "\(result.rows.count)"
                } else {
                    let error = response.errors
                    if !error.isEmpty, let message = error[0] as? String {
                        strongSelf.error = APIError.identified(message: message)
                        strongSelf.showAlert = true
                    } else if !response.message.isEmpty {
                        strongSelf.error = APIError.identified(message: response.message)
                        strongSelf.showAlert = true
                    }
                }
            }, onFailure: { error in
                if let errorAPI = error as? APIError {
                    self.error = errorAPI
                }
                self.showProgressView = false
                self.showAlert = true
            })
            .disposed(by: disposedBag)
    }

    func disconnectSession() {
        guard let device = sessionSelect else {
            return
        }
        if device.id == AppSetting.shared.currentSessionId {

            AppSetting.shared.selectAutoConnect = ItemCellType.off.rawValue
            NetworkManager.shared.checkAutoconnect()

            Task {
                await NetworkManager.shared.disconnectCurrentSession()
            }
        }
        showProgressView = true
        ServiceManager.shared.disconnectSession(sessionId: device.id, terminal: true)
            .subscribe { [weak self] response in
                self?.showProgressView = false
                guard let self = self else {
                    return
                }

                if response.success {
                    self.getListSession()
                    self.showSessionTerminatedAlert = true
                } else {
                    let error = response.errors
                    if !error.isEmpty, let message = error[0] as? String {
                        self.error = APIError.identified(message: message)
                        self.showAlert = true
                    } else if !response.message.isEmpty {
                        self.error = APIError.identified(message: response.message)
                        self.showAlert = true
                    }
                }
            } onFailure: { error in
                if let errorAPI = error as? APIError {
                    self.error = errorAPI
                    self.showAlert = true
                }
                self.showProgressView = false
            }
            .disposed(by: disposedBag)
    }
}
