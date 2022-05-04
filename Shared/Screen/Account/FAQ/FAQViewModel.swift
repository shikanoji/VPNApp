//
//  FAQViewModel.swift
//  SysVPN
//
//  Created by Nguyễn Đình Thạch on 09/02/2022.
//

import Foundation

class FAQViewModel: ObservableObject {
    @Published var questions: [QuestionModel]
    init() {
        questions = QuestionModel.mockQuestionList
    }
}
