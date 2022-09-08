//
//  DeviceOnline.swift
//  SysVPN
//
//  Created by Da Phan Van on 18/01/2022.
//

import Foundation
import SwiftUI

struct SessionResult: Codable {
    var page: Int
    var limit: Int
    var totalPages: Int
    var totalResults: Int
    var rows: [SessionVPN]
    
    enum CodingKeys: String, CodingKey {
        case page
        case limit
        case totalPages
        case totalResults
        case rows
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let _page = try? values.decode(Int.self, forKey: .page) {
            page = _page
        } else {
            page = 0
        }
        
        if let _limit = try? values.decode(Int.self, forKey: .limit) {
            limit = _limit
        } else {
            limit = 0
        }
        
        if let _totalPages = try? values.decode(Int.self, forKey: .totalPages) {
            totalPages = _totalPages
        } else {
            totalPages = 0
        }
        
        if let _totalResults = try? values.decode(Int.self, forKey: .totalResults) {
            totalResults = _totalResults
        } else {
            totalResults = 0
        }
        
        if let _rows = try? values.decode([SessionVPN].self, forKey: .rows) {
            rows = _rows
        } else {
            rows = []
        }
    }
}

struct SessionVPN: Codable, Identifiable, Equatable {
    var id: String
    
    var deviceId: String
    var deviceCode: String
    var deviceBrand: String
    var deviceApiVersion: String
    var deviceFingerprint: String
    var deviceOs: String
    var deviceSupportedAbis: [String]
    var deviceModel: String
    var deviceIsRoot: Int
    var deviceHardware: String
    var deviceManufacture: String
    var deviceFreeMemory: Int
    
    var osBuildNumber: String
    var osIncremental: String
    var osSecurityPath: String
    var appVersion: String
    var appBundleId: String
    var isEmulator: Int
    var isTablet: Int
    var totalByteIn: Int?
    var totalByteOut: Int?
    var connectionType: String
    var connectionProtocol: String
    var disconnectedAt: Int
    var disconnectedBy: String
    var userId: Int
    var serverIp: String
    var isActive: Int
    var userCountryCode: String
    var userCountryName: String
    var userCity: String
    var userIp: String
    var createdAt: String
    var connectedAt: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case deviceId
        case deviceCode
        case deviceBrand
        case deviceApiVersion
        case deviceFingerprint
        case deviceOs
        case deviceSupportedAbis
        case deviceModel
        case deviceIsRoot
        case deviceHardware
        case deviceManufacture
        case deviceFreeMemory
        
        case osBuildNumber
        case osIncremental
        case osSecurityPath
        case appVersion
        case appBundleId
        case isEmulator
        case isTablet
        case totalByteIn
        case totalByteOut
        case connectionType
        case connectionProtocol
        case disconnectedAt
        case disconnectedBy
        case userId
        case serverIp
        case isActive
        case userCountryCode
        case userCountryName
        case userCity
        case userIp
        case createdAt
        case connectedAt
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let _id = try? values.decode(String.self, forKey: .id) {
            self.id = _id
        } else {
            self.id = ""
        }
        
        if let _deviceId = try? values.decode(String.self, forKey: .deviceId) {
            self.deviceId = _deviceId
        } else {
            self.deviceId = ""
        }
        
        if let _deviceCode = try? values.decode(String.self, forKey: .deviceCode) {
            self.deviceCode = _deviceCode
        } else {
            self.deviceCode = ""
        }
        
        if let _deviceBrand = try? values.decode(String.self, forKey: .deviceBrand) {
            self.deviceBrand = _deviceBrand
        } else {
            self.deviceBrand = ""
        }
        
        if let _deviceApiVersion = try? values.decode(String.self, forKey: .deviceApiVersion) {
            self.deviceApiVersion = _deviceApiVersion
        } else {
            self.deviceApiVersion = ""
        }
        
        if let _deviceFingerprint = try? values.decode(String.self, forKey: .deviceFingerprint) {
            self.deviceFingerprint = _deviceFingerprint
        } else {
            self.deviceFingerprint = ""
        }
        
        if let _deviceOs = try? values.decode(String.self, forKey: .deviceOs) {
            self.deviceOs = _deviceOs
        } else {
            self.deviceOs = ""
        }
        
        if let _deviceSupportedAbis = try? values.decode([String].self, forKey: .deviceSupportedAbis) {
            self.deviceSupportedAbis = _deviceSupportedAbis
        } else {
            self.deviceSupportedAbis = []
        }
        
        if let _deviceModel = try? values.decode(String.self, forKey: .deviceModel) {
            self.deviceModel = _deviceModel
        } else {
            self.deviceModel = ""
        }
        
        if let _deviceIsRoot = try? values.decode(Int.self, forKey: .deviceIsRoot) {
            self.deviceIsRoot = _deviceIsRoot
        } else {
            self.deviceIsRoot = 0
        }
        
        if let _deviceHardware = try? values.decode(String.self, forKey: .deviceHardware) {
            self.deviceHardware = _deviceHardware
        } else {
            self.deviceHardware = ""
        }
        
        if let _deviceManufacture = try? values.decode(String.self, forKey: .deviceManufacture) {
            self.deviceManufacture = _deviceManufacture
        } else {
            self.deviceManufacture = ""
        }
        
        if let _deviceFreeMemory = try? values.decode(Int.self, forKey: .deviceFreeMemory) {
            self.deviceFreeMemory = _deviceFreeMemory
        } else {
            self.deviceFreeMemory = 0
        }
        
        if let _osBuildNumber = try? values.decode(String.self, forKey: .osBuildNumber) {
            self.osBuildNumber = _osBuildNumber
        } else {
            self.osBuildNumber = ""
        }
        
        if let _osIncremental = try? values.decode(String.self, forKey: .osIncremental) {
            self.osIncremental = _osIncremental
        } else {
            self.osIncremental = ""
        }
        
        if let _osSecurityPath = try? values.decode(String.self, forKey: .osSecurityPath) {
            self.osSecurityPath = _osSecurityPath
        } else {
            self.osSecurityPath = ""
        }
        
        if let _appVersion = try? values.decode(String.self, forKey: .appVersion) {
            self.appVersion = _appVersion
        } else {
            self.appVersion = ""
        }
        
        if let _appBundleId = try? values.decode(String.self, forKey: .appBundleId) {
            self.appBundleId = _appBundleId
        } else {
            self.appBundleId = ""
        }
        
        if let _isEmulator = try? values.decode(Int.self, forKey: .isEmulator) {
            self.isEmulator = _isEmulator
        } else {
            self.isEmulator = 0
        }
        
        if let _isTablet = try? values.decode(Int.self, forKey: .isTablet) {
            self.isTablet = _isTablet
        } else {
            self.isTablet = 0
        }
        
        if let _totalByteIn = try? values.decode(Int.self, forKey: .totalByteIn) {
            self.totalByteIn = _totalByteIn
        } else {
            self.totalByteIn = 0
        }
        
        if let _totalByteOut = try? values.decode(Int.self, forKey: .totalByteOut) {
            self.totalByteOut = _totalByteOut
        } else {
            self.totalByteOut = 0
        }
        
        if let _connectionType = try? values.decode(String.self, forKey: .connectionType) {
            self.connectionType = _connectionType
        } else {
            self.connectionType = ""
        }
        
        if let _connectionProtocol = try? values.decode(String.self, forKey: .connectionProtocol) {
            self.connectionProtocol = _connectionProtocol
        } else {
            self.connectionProtocol = ""
        }
        
        if let _disconnectedAt = try? values.decode(Int.self, forKey: .disconnectedAt) {
            self.disconnectedAt = _disconnectedAt
        } else {
            self.disconnectedAt = 0
        }
        
        if let _disconnectedBy = try? values.decode(String.self, forKey: .disconnectedBy) {
            self.disconnectedBy = _disconnectedBy
        } else {
            self.disconnectedBy = ""
        }
        
        if let _userId = try? values.decode(Int.self, forKey: .userId) {
            self.userId = _userId
        } else {
            self.userId = 0
        }
        
        if let _serverIp = try? values.decode(String.self, forKey: .serverIp) {
            self.serverIp = _serverIp
        } else {
            self.serverIp = ""
        }
        
        if let _isActive = try? values.decode(Int.self, forKey: .isActive) {
            self.isActive = _isActive
        } else {
            self.isActive = 0
        }
        
        if let _userCountryCode = try? values.decode(String.self, forKey: .userCountryCode) {
            self.userCountryCode = _userCountryCode
        } else {
            self.userCountryCode = ""
        }
        
        if let _userCountryName = try? values.decode(String.self, forKey: .userCountryName) {
            self.userCountryName = _userCountryName
        } else {
            self.userCountryName = ""
        }
        
        if let _userCity = try? values.decode(String.self, forKey: .userCity) {
            self.userCity = _userCity
        } else {
            self.userCity = ""
        }
        
        if let _userIp = try? values.decode(String.self, forKey: .userIp) {
            self.userIp = _userIp
        } else {
            self.userIp = ""
        }
        
        if let _createdAt = try? values.decode(String.self, forKey: .createdAt) {
            self.createdAt = _createdAt
        } else {
            self.createdAt = ""
        }
        
        if let _connectedAt = try? values.decode(Int.self, forKey: .connectedAt) {
            self.connectedAt = _connectedAt
        } else {
            self.connectedAt = 0
        }
    }
    
    func getSubContent() -> String {
        var subContent = userIp
        
        if userCity != "" && userCountryName != "" {
            subContent += " - " + userCity + ", " + userCountryName
        }
        
        return subContent
    }
}
