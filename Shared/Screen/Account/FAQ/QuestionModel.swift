//
//  QA.swift
//  SysVPN
//
//  Created by Nguyễn Đình Thạch on 08/02/2022.
//

import Foundation

struct QuestionModel: Codable, Identifiable {
    static var mockQuestionList: [QuestionModel] {
        return [QuestionModel(id: "1", question: "What is a VPN?", answer: ""),
                QuestionModel(id: "2", question: "What can I do with a VPN?", answer: ""),
                QuestionModel(id: "3", question: "What services can I access with a VPN?", answer: ""),
                QuestionModel(id: "4", question: "Will a VPN slow my internet connection?", answer: ""),]
    }
    var id: String
    var question: String
    var answer: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case question
        case answer
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        question = try values.decode(String.self, forKey: .question)
        answer = try values.decode(String.self, forKey: .answer)

    }
    
    init(id: String, question: String, answer: String) {
        self.id = id
        self.question = question
        self.answer = answer
    }
}
