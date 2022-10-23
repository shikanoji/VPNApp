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
            id = _id
        } else {
            id = nil
        }
        
        if let _title = try? values.decode(String.self, forKey: .title) {
            title = _title
        } else {
            title = ""
        }
        
        if let _url = try? values.decode(String.self, forKey: .url) {
            url = _url
        } else {
            url = ""
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
            id = _id
        } else {
            id = nil
        }
        
        if let _name = try? values.decode(String.self, forKey: .name) {
            name = _name
        } else {
            name = ""
        }
        
        if let _faqs = try? values.decode([QuestionModel].self, forKey: .faqs) {
            faqs = _faqs
        } else {
            faqs = []
        }
    }
}
