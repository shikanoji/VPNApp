//
//  DeviceViewModel.swift
//  SysVPN
//
//  Created by Nguyễn Đình Thạch on 08/02/2022.
//

import Foundation
import RxSwift
import SwiftUI

extension Binding where Value == Int {
    public func string() -> Binding<String> {
        return Binding<String>(get:{ String(self.wrappedValue) },
                               set: { self.wrappedValue = Int($0) ?? 0})
    }
}

class SessionVPNViewModel: ObservableObject {
    @Published var deviceList: [SessionVPN] = []
    @Published var showAlert: Bool = false
    @Published var showProgressView: Bool = false
    
    @Published var currentNumberDevice: Int = AppSetting.shared.currentNumberDevice
     
    var error: APIError?
    var limit = AppSetting.shared.maxNumberDevices
    
    let disposedBag = DisposeBag()
    
    init() {}
    
    @MainActor func getListSession() {
        showProgressView = true
        
        ServiceManager.shared.getListSession()
            .subscribe(onSuccess: { [weak self] response in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.showProgressView = false
                if let result = response.result {
                    strongSelf.deviceList = result.rows
                    strongSelf.currentNumberDevice = strongSelf.deviceList.count
                } else {
                    let error = response.errors
                    if error.count > 0, let message = error[0] as? String {
                        strongSelf.error = APIError.identified(message: message)
                        strongSelf.showAlert = true
                    } else if !response.message.isEmpty {
                        strongSelf.error = APIError.identified(message: response.message)
                        strongSelf.showAlert = true
                    }
                }
            }, onFailure: { error in
                self.showProgressView = false
                self.error = APIError.identified(message: error.localizedDescription)
                self.showAlert = true
            })
            .disposed(by: disposedBag)
    }
    
    func disconnectSession(_ device: SessionVPN) {
        if device.id == AppSetting.shared.currentSessionId {
            NotificationCenter.default.post(name: Constant.NameNotification.disconnectCurrentSession, object: nil)
        } else {
            showProgressView = true
            ServiceManager.shared.disconnectSession(sessionId: device.id, terminal: true)
                .subscribe { [weak self] response in
                    guard let `self` = self else {
                        return
                    }
                    
                    self.showProgressView = false
                    
                    if response.success {
                        Task {
                            await self.getListSession()
                        }
                    } else {
                        let error = response.errors
                        if error.count > 0, let message = error[0] as? String {
                            self.error = APIError.identified(message: message)
                            self.showAlert = true
                        } else if !response.message.isEmpty {
                            self.error = APIError.identified(message: response.message)
                            self.showAlert = true
                        }
                    }
                } onFailure: { error in
                    self.showProgressView = false
                    self.error = APIError.identified(message: error.localizedDescription)
                    self.showAlert = true
                }
                .disposed(by: disposedBag)
        }
    }
}
