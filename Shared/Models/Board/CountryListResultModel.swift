//
//  CountryListResultModel.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 17/02/2022.
//

import Foundation
import SwiftyJSON

struct CountryListResultModel: Decodable {
    var availableCountries: [Node]
    var recommendedCountries: [Node]
    var clientCountryDetail: Node
    var staticServers: [StaticServer]
    
    enum CodingKeys: String, CodingKey {
        case availableCountries
        case recommendedCountries
        case staticServers
        case clientCountryDetail
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        availableCountries = try values.decode([Node].self, forKey: .availableCountries)
        recommendedCountries = try values.decode([Node].self, forKey: .recommendedCountries)
        staticServers = try values.decode([StaticServer].self, forKey: .staticServers)
        clientCountryDetail = try values.decode(Node.self, forKey: .clientCountryDetail)
    }
}
