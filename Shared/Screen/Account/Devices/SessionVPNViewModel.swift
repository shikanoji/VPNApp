//
//  DeviceViewModel.swift
//  SysVPN
//
//  Created by Nguyễn Đình Thạch on 08/02/2022.
//

import Foundation
import RxSwift

class SessionVPNViewModel: ObservableObject {
    @Published var deviceList: [SessionVPN] = []
    @Published var showAlert: Bool = false
    @Published var showProgressView: Bool = false
    
    @Published var currentNumberDevice: Int = AppSetting.shared.currentNumberDevice {
        didSet {
            AppSetting.shared.currentNumberDevice = currentNumberDevice
        }
    }
     
    var error: APIError?
    var currentPage = 1
    var limit = AppSetting.shared.maxNumberDevices
    var isLoadMoreEnable = false
    
    let disposedBag = DisposeBag()
    
    init() {
//        getListSession()
    }
    
    func getListSession(loadMore: Bool = false) {
        if loadMore {
            if !isLoadMoreEnable {
                return
            } else {
                currentPage += 1
            }
        } else {
            currentPage = 1
        }
        
        showProgressView = true
        
        ServiceManager.shared.getListSession(page: currentPage, limit: limit)
            .subscribe { [weak self] response in
                guard let `self` = self else {
                    return
                }
                
                self.showProgressView = false
                
                if let result = response.result {
                    if result.totalResults == 0 || result.totalResults >= self.limit {
                        self.isLoadMoreEnable = false
                    } else {
                        self.isLoadMoreEnable = true
                    }
                    
                    DispatchQueue.main.async {
                        if loadMore {
                            self.deviceList += result.rows
                        } else {
                            self.deviceList = result.rows
                        }
                        
                        if self.deviceList.count >= self.limit {
                            self.deviceList = Array(self.deviceList.prefix(upTo: self.limit))
                        }
                        
                        self.currentNumberDevice = self.deviceList.count
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
    
    func disconnectSession(_ device: SessionVPN) {
        showProgressView = true
        
        ServiceManager.shared.disconnectSession(sessionId: device.id, terminal: true)
            .subscribe { [weak self] response in
                guard let `self` = self else {
                    return
                }
                
                self.showProgressView = false
                
                if response.success {
                    DispatchQueue.main.async {
                        self.deviceList = self.deviceList.filter { $0.id != device.id }
                        self.currentNumberDevice = self.deviceList.count
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
