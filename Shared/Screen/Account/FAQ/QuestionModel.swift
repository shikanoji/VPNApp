//
//  QA.swift
//  SysVPN
//
//  Created by Nguyễn Đình Thạch on 08/02/2022.
//

import Foundation

struct QuestionModel: Codable, Identifiable, Equatable {
    
    var id: Int? = nil
    var title = ""
    var url = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case url
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let _id = try? values.decode(Int.self, forKey: .id) {
            self.id = _id
        } else {
            self.id = nil
        }
        
        if let _title = try? values.decode(String.self, forKey: .title) {
            self.title = _title
        } else {
            self.title = ""
        }
        
        if let _url = try? values.decode(String.self, forKey: .url) {
            self.url = _url
        } else {
            self.url = ""
        }
    }
    
    init() { }
}

struct TopicQuestionModel: Codable, Identifiable, Equatable {
    
    var id: Int?
    var name: String
    var faqs: [QuestionModel]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case faqs
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let _id = try? values.decode(Int.self, forKey: .id) {
            self.id = _id
        } else {
            self.id = nil
        }
        
        if let _name = try? values.decode(String.self, forKey: .name) {
            self.name = _name
        } else {
            self.name = ""
        }
        
        if let _faqs = try? values.decode([QuestionModel].self, forKey: .faqs) {
            self.faqs = _faqs
        } else {
            self.faqs = []
        }
    }
}
