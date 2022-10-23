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
            id = _id
        } else {
            id = ""
        }
        
        if let _deviceId = try? values.decode(String.self, forKey: .deviceId) {
            deviceId = _deviceId
        } else {
            deviceId = ""
        }
        
        if let _deviceCode = try? values.decode(String.self, forKey: .deviceCode) {
            deviceCode = _deviceCode
        } else {
            deviceCode = ""
        }
        
        if let _deviceBrand = try? values.decode(String.self, forKey: .deviceBrand) {
            deviceBrand = _deviceBrand
        } else {
            deviceBrand = ""
        }
        
        if let _deviceApiVersion = try? values.decode(String.self, forKey: .deviceApiVersion) {
            deviceApiVersion = _deviceApiVersion
        } else {
            deviceApiVersion = ""
        }
        
        if let _deviceFingerprint = try? values.decode(String.self, forKey: .deviceFingerprint) {
            deviceFingerprint = _deviceFingerprint
        } else {
            deviceFingerprint = ""
        }
        
        if let _deviceOs = try? values.decode(String.self, forKey: .deviceOs) {
            deviceOs = _deviceOs
        } else {
            deviceOs = ""
        }
        
        if let _deviceSupportedAbis = try? values.decode([String].self, forKey: .deviceSupportedAbis) {
            deviceSupportedAbis = _deviceSupportedAbis
        } else {
            deviceSupportedAbis = []
        }
        
        if let _deviceModel = try? values.decode(String.self, forKey: .deviceModel) {
            deviceModel = _deviceModel
        } else {
            deviceModel = ""
        }
        
        if let _deviceIsRoot = try? values.decode(Int.self, forKey: .deviceIsRoot) {
            deviceIsRoot = _deviceIsRoot
        } else {
            deviceIsRoot = 0
        }
        
        if let _deviceHardware = try? values.decode(String.self, forKey: .deviceHardware) {
            deviceHardware = _deviceHardware
        } else {
            deviceHardware = ""
        }
        
        if let _deviceManufacture = try? values.decode(String.self, forKey: .deviceManufacture) {
            deviceManufacture = _deviceManufacture
        } else {
            deviceManufacture = ""
        }
        
        if let _deviceFreeMemory = try? values.decode(Int.self, forKey: .deviceFreeMemory) {
            deviceFreeMemory = _deviceFreeMemory
        } else {
            deviceFreeMemory = 0
        }
        
        if let _osBuildNumber = try? values.decode(String.self, forKey: .osBuildNumber) {
            osBuildNumber = _osBuildNumber
        } else {
            osBuildNumber = ""
        }
        
        if let _osIncremental = try? values.decode(String.self, forKey: .osIncremental) {
            osIncremental = _osIncremental
        } else {
            osIncremental = ""
        }
        
        if let _osSecurityPath = try? values.decode(String.self, forKey: .osSecurityPath) {
            osSecurityPath = _osSecurityPath
        } else {
            osSecurityPath = ""
        }
        
        if let _appVersion = try? values.decode(String.self, forKey: .appVersion) {
            appVersion = _appVersion
        } else {
            appVersion = ""
        }
        
        if let _appBundleId = try? values.decode(String.self, forKey: .appBundleId) {
            appBundleId = _appBundleId
        } else {
            appBundleId = ""
        }
        
        if let _isEmulator = try? values.decode(Int.self, forKey: .isEmulator) {
            isEmulator = _isEmulator
        } else {
            isEmulator = 0
        }
        
        if let _isTablet = try? values.decode(Int.self, forKey: .isTablet) {
            isTablet = _isTablet
        } else {
            isTablet = 0
        }
        
        if let _totalByteIn = try? values.decode(Int.self, forKey: .totalByteIn) {
            totalByteIn = _totalByteIn
        } else {
            totalByteIn = 0
        }
        
        if let _totalByteOut = try? values.decode(Int.self, forKey: .totalByteOut) {
            totalByteOut = _totalByteOut
        } else {
            totalByteOut = 0
        }
        
        if let _connectionType = try? values.decode(String.self, forKey: .connectionType) {
            connectionType = _connectionType
        } else {
            connectionType = ""
        }
        
        if let _connectionProtocol = try? values.decode(String.self, forKey: .connectionProtocol) {
            connectionProtocol = _connectionProtocol
        } else {
            connectionProtocol = ""
        }
        
        if let _disconnectedAt = try? values.decode(Int.self, forKey: .disconnectedAt) {
            disconnectedAt = _disconnectedAt
        } else {
            disconnectedAt = 0
        }
        
        if let _disconnectedBy = try? values.decode(String.self, forKey: .disconnectedBy) {
            disconnectedBy = _disconnectedBy
        } else {
            disconnectedBy = ""
        }
        
        if let _userId = try? values.decode(Int.self, forKey: .userId) {
            userId = _userId
        } else {
            userId = 0
        }
        
        if let _serverIp = try? values.decode(String.self, forKey: .serverIp) {
            serverIp = _serverIp
        } else {
            serverIp = ""
        }
        
        if let _isActive = try? values.decode(Int.self, forKey: .isActive) {
            isActive = _isActive
        } else {
            isActive = 0
        }
        
        if let _userCountryCode = try? values.decode(String.self, forKey: .userCountryCode) {
            userCountryCode = _userCountryCode
        } else {
            userCountryCode = ""
        }
        
        if let _userCountryName = try? values.decode(String.self, forKey: .userCountryName) {
            userCountryName = _userCountryName
        } else {
            userCountryName = ""
        }
        
        if let _userCity = try? values.decode(String.self, forKey: .userCity) {
            userCity = _userCity
        } else {
            userCity = ""
        }
        
        if let _userIp = try? values.decode(String.self, forKey: .userIp) {
            userIp = _userIp
        } else {
            userIp = ""
        }
        
        if let _createdAt = try? values.decode(String.self, forKey: .createdAt) {
            createdAt = _createdAt
        } else {
            createdAt = ""
        }
        
        if let _connectedAt = try? values.decode(Int.self, forKey: .connectedAt) {
            connectedAt = _connectedAt
        } else {
            connectedAt = 0
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
