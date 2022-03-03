//
//  IpInfoResult.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 28/02/2022.
//

import Foundation
import SwiftyJSON

struct IpInfoResultModel: Decodable {
    var ip: String
    var lastChange: Double?
    var country: String
    var city: String
    
    enum CodingKeys: String, CodingKey {
        case ip
        case lastChange
        case country
        case city
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let _ip = try? values.decode(String.self, forKey: .ip){
            self.ip = _ip
        } else {
            self.ip = ""
        }
        
        if let _lastChange = try? values.decode(Double.self, forKey: .lastChange){
            self.lastChange = _lastChange
        } else {
            self.lastChange = nil
        }
        
        if let _country = try? values.decode(String.self, forKey: .country){
            self.country = _country
        } else {
            self.country = ""
        }
        
        if let _city = try? values.decode(String.self, forKey: .city){
            self.city = _city
        } else {
            self.city = ""
        }
    }
}
