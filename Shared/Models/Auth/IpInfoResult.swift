//
//  IpInfoResult.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 28/02/2022.
//

import Foundation
import SwiftyJSON

struct VPNSetting: Decodable {
    var defaultTech: String?
    var defaultProtocol: String?
    
    enum CodingKeys: String, CodingKey {
        case defaultTech
        case defaultProtocol
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let _defaultTech = try? values.decode(String.self, forKey: .defaultTech) {
            self.defaultTech = _defaultTech
        } else {
            self.defaultTech = nil
        }
        
        if let _defaultProtocol = try? values.decode(String.self, forKey: .defaultProtocol) {
            self.defaultProtocol = _defaultProtocol
        } else {
            self.defaultProtocol = nil
        }
    }
}

struct AppSettings: Decodable {
    var forceUpdateVersions: [String]
    var vpn: VPNSetting?
    
    enum CodingKeys: String, CodingKey {
        case forceUpdateVersions
        case vpn
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let _forceUpdateVersions = try? values.decode([String].self, forKey: .forceUpdateVersions) {
            self.forceUpdateVersions = _forceUpdateVersions
        } else {
            self.forceUpdateVersions = []
        }
        
        if let _vpn = try? values.decode(VPNSetting.self, forKey: .vpn) {
            self.vpn = _vpn
        } else {
            self.vpn = nil
        }
    }
}

struct AppSettingsResultAPI: Decodable {
    var lastChange: Double?
    var ipInfo: IpInfoResultModel
    var appSettings: AppSettings?
    
    enum CodingKeys: String, CodingKey {
        case lastChange
        case ipInfo
        case appSettings
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let _lastChange = try? values.decode(Double.self, forKey: .lastChange) {
            self.lastChange = _lastChange
        } else {
            self.lastChange = nil
        }
        
        ipInfo = try values.decode(IpInfoResultModel.self, forKey: .ipInfo)
        
        if let _appSettings = try? values.decode(AppSettings.self, forKey: .appSettings) {
            self.appSettings = _appSettings
        } else {
            self.appSettings = nil
        }
    }
}

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
