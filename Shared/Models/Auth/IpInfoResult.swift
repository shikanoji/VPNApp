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
            defaultTech = _defaultTech
        } else {
            defaultTech = nil
        }
        
        if let _defaultProtocol = try? values.decode(String.self, forKey: .defaultProtocol) {
            defaultProtocol = _defaultProtocol
        } else {
            defaultProtocol = nil
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
            forceUpdateVersions = _forceUpdateVersions
        } else {
            forceUpdateVersions = []
        }
        
        if let _vpn = try? values.decode(VPNSetting.self, forKey: .vpn) {
            vpn = _vpn
        } else {
            vpn = nil
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
            lastChange = _lastChange
        } else {
            lastChange = nil
        }
        
        ipInfo = try values.decode(IpInfoResultModel.self, forKey: .ipInfo)
        
        if let _appSettings = try? values.decode(AppSettings.self, forKey: .appSettings) {
            appSettings = _appSettings
        } else {
            appSettings = nil
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
        if let _ip = try? values.decode(String.self, forKey: .ip) {
            ip = _ip
        } else {
            ip = ""
        }
        
        if let _lastChange = try? values.decode(Double.self, forKey: .lastChange) {
            lastChange = _lastChange
        } else {
            lastChange = nil
        }
        
        if let _countryName = try? values.decode(String.self, forKey: .countryName) {
            countryName = _countryName
        } else {
            countryName = ""
        }
        
        if let _countryCode = try? values.decode(String.self, forKey: .countryCode) {
            countryCode = _countryCode
        } else {
            countryCode = ""
        }
        
        if let _city = try? values.decode(String.self, forKey: .city) {
            city = _city
        } else {
            city = ""
        }
        
        if let _isp = try? values.decode(String.self, forKey: .isp) {
            isp = _isp
        } else {
            isp = ""
        }
    }
}
