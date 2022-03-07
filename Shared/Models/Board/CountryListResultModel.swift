//
//  CountryListResultModel.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 17/02/2022.
//

import Foundation
import SwiftyJSON

struct CountryListResultModel: Codable {
    var availableCountries: [Node]
    var recommendedCountries: [Node]
    var clientCountryDetail: Node?
    var staticServers: [StaticServer]
    
    enum CodingKeys: String, CodingKey {
        case availableCountries
        case recommendedCountries
        case staticServers
        case clientCountryDetail
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let _availableCountries = try? values.decode([Node].self, forKey: .availableCountries) {
            availableCountries = _availableCountries
        } else {
            availableCountries = []
        }
        
        if let _recommendedCountries = try? values.decode([Node].self, forKey: .recommendedCountries) {
            recommendedCountries = _recommendedCountries
        } else {
            recommendedCountries = []
        }
        
        if let _staticServers = try? values.decode([StaticServer].self, forKey: .staticServers) {
            staticServers = _staticServers
        } else {
            staticServers = []
        }
        
        if let _clientCountryDetail = try? values.decode(Node.self, forKey: .clientCountryDetail) {
            clientCountryDetail = _clientCountryDetail
        } else {
            clientCountryDetail = nil
        }
        
    }
}
