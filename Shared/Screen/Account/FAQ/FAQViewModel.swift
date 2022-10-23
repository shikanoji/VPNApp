//
//  FAQViewModel.swift
//  SysVPN
//
//  Created by Nguyễn Đình Thạch on 09/02/2022.
//

import Foundation
import RxSwift

class FAQViewModel: ObservableObject {
    @Published var topicQuestionList: [TopicQuestionModel] = []
    @Published var showAlert: Bool = false
    @Published var showProgressView: Bool = false
    
    var error: APIError?
    let disposedBag = DisposeBag()
    
    init() {
        getTopicQuestionList()
    }
    
    func getTopicQuestionList() {
        
        showProgressView = true
        
        ServiceManager.shared.getTopicQuestionList()
            .subscribe { [weak self] response in
                guard let self = self else {
                    return
                }
                
                self.showProgressView = false
                
                if let result = response.result {
                    
                    DispatchQueue.main.async {
                        self.topicQuestionList = result
                    }
                    
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
                self.showProgressView = false
                self.error = APIError.identified(message: error.localizedDescription)
                self.showAlert = true
            }
            .disposed(by: disposedBag)
    }
}
