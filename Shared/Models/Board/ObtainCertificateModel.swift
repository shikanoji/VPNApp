//
//  obtainCertificateModel.swift
//  SysVPN
//
//  Created by Da Phan Van on 29/04/2022.
//

import Foundation

struct Interface: Codable {
    var privateKey: String
    var address: String
    var dns: String
    
    enum CodingKeys: String, CodingKey {
        case privateKey = "PrivateKey"
        case address = "Address"
        case dns = "DNS"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let _privateKey = try? values.decode(String.self, forKey: .privateKey) {
            privateKey = _privateKey
        } else {
            privateKey = ""
        }
        
        if let _address = try? values.decode(String.self, forKey: .address) {
            address = _address
        } else {
            address = ""
        }
        
        if let _dns = try? values.decode(String.self, forKey: .dns) {
            dns = _dns
        } else {
            dns = ""
        }
    }
    
    func convertToString() -> String {
        var stringData = "[Interface]\n"
        let spaceLine = "\n"
        
        stringData += "PrivateKey = " + privateKey + spaceLine
        stringData += "Address = " + address + spaceLine
        stringData += "DNS = " + dns + spaceLine
        
        return stringData
    }
}

struct Peer: Codable {
    var publicKey: String
    var allowedIPs: String
    var endpoint: String
    
    enum CodingKeys: String, CodingKey {
        case publicKey = "PublicKey"
        case allowedIPs = "AllowedIPs"
        case endpoint = "Endpoint"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let _privateKey = try? values.decode(String.self, forKey: .publicKey) {
            publicKey = _privateKey
        } else {
            publicKey = ""
        }
        
        if let _allowedIPs = try? values.decode(String.self, forKey: .allowedIPs) {
            allowedIPs = _allowedIPs
        } else {
            allowedIPs = ""
        }
        
        if let _endpoint = try? values.decode(String.self, forKey: .endpoint) {
            endpoint = _endpoint
        } else {
            endpoint = ""
        }
    }
    
    func convertToString() -> String {
        var stringData = "[Peer]\n"
        let spaceLine = "\n"
        
        stringData += "PublicKey = " + publicKey + spaceLine
        stringData += "AllowedIPs = " + allowedIPs + spaceLine
        stringData += "Endpoint = " + endpoint + spaceLine
        
        return stringData
    }
}

struct ObtainCertificateModel: Codable {
    var server: Server?
    var interface: Interface?
    var peer: Peer?
    var sessionId: String?
    var allowReconnect: Bool = true
    var exceedLimit: Bool = false
    var dns: [String] = []
    
    enum CodingKeys: String, CodingKey {
        case server
        case interface = "Interface"
        case peer = "Peer"
        case sessionId
        case allowReconnect
        case exceedLimit
        case dns
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let value = try? values.decode([String].self, forKey: .dns) {
            dns = value
        } else {
            dns = []
        }
        
        if let _exceedLimit = try? values.decode(Bool.self, forKey: .exceedLimit) {
            exceedLimit = _exceedLimit
        } else {
            exceedLimit = false
        }
        
        if let _allowReconnect = try? values.decode(Bool.self, forKey: .allowReconnect) {
            allowReconnect = _allowReconnect
        } else {
            allowReconnect = true
        }
        
        if let _server = try? values.decode(Server.self, forKey: .server) {
            server = _server
        } else {
            server = nil
        }
        
        if let _interface = try? values.decode(Interface.self, forKey: .interface) {
            interface = _interface
        } else {
            interface = nil
        }
        
        if let _peer = try? values.decode(Peer.self, forKey: .peer) {
            peer = _peer
        } else {
            peer = nil
        }
        
        if let _sessionId = try? values.decode(String.self, forKey: .sessionId) {
            sessionId = _sessionId
        } else {
            sessionId = nil
        }
    }
    
    func convertToString() -> String {
        return (interface?.convertToString() ?? "") + "\n" + (peer?.convertToString() ?? "")
    }
}
