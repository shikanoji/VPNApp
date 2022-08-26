//
//  AutoConnectDestinationSelectViewModel.swift
//  SysVPN (iOS)
//
//  Created by Nguyen Dinh Thach on 29/06/2022.
//

import Foundation
import RxSwift

class AutoConnectDestinationSelectViewModel: ObservableObject {
    @Published var showProgressView: Bool = false
    var disposedBag = DisposeBag()
    var error: APIError?
    @Published var showAlert: Bool = false
    @Published var shouldAutoCloseView: Bool = false
    @Published var locationData: [NodeGroup] = []
    @Published var node: Node? = AppSetting.shared.getAutoConnectNode() {
        didSet {
            AppSetting.shared.saveAutoConnectNode(node)
            shouldAutoCloseView = true
        }
    }
    
    func getCountryList() {
        guard Connectivity.sharedInstance.isReachable else {
            return
        }
        
        self.showProgressView = true
        
        ServiceManager.shared.getCountryList()
            .subscribe { [weak self] response in
                guard let `self` = self else {
                    return
                }
                self.showProgressView = false
                if let result = response.result {
                    AppSetting.shared.saveDataMap(result)
                    self.configLocation(result)
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
    
    func configLocation(_ result: CountryListResultModel) {
        locationData = [
            NodeGroup(nodeList: result.recommendedCountries, type: .recommend),
            NodeGroup(nodeList: result.availableCountries, type: .all),
        ]
    }
}
