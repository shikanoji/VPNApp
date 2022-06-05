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
    var countryName: String
    var countryCode: String
    var city: String
    var isp: String
    
    enum CodingKeys: String, CodingKey {
        case ip
        case lastChange
        case countryName
        case countryCode
        case city
        case isp
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
        
        if let _countryName = try? values.decode(String.self, forKey: .countryName){
            self.countryName = _countryName
        } else {
            self.countryName = ""
        }
        
        if let _countryCode = try? values.decode(String.self, forKey: .countryCode){
            self.countryCode = _countryCode
        } else {
            self.countryCode = ""
        }
        
        if let _city = try? values.decode(String.self, forKey: .city){
            self.city = _city
        } else {
            self.city = ""
        }
        
        if let _isp = try? values.decode(String.self, forKey: .isp){
            self.isp = _isp
        } else {
            self.isp = ""
        }
    }
}
