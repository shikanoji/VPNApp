//
//  RequestCertificateModel.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 21/04/2022.
//

import Foundation

struct Server: Codable {
    var id: Int
    var ipAddress: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case ipAddress
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let _id = try? values.decode(Int.self, forKey: .id) {
            id = _id
        } else {
            id = 0
        }
        
        if let _ipAddress = try? values.decode(String.self, forKey: .ipAddress) {
            ipAddress = _ipAddress
        } else {
            ipAddress = ""
        }
    }
}

struct ConnectionDetails: Codable {
    var client: String
    var dev: String
    var proto: String
    var remote: String
    var cipher: String
    var auth: String
    var authNocache: String
    var tlsVersionMin: String
    var tlsCipher: String
    var resolvRetry: String
    var remoteCertTls: String
    var nobind: String
    var persistKey: String
    var muteReplayWarnings: String
    var verb: Int
    var ca: String
    var cert: String
    var key: String
    var tlsCrypt: String
    
    enum CodingKeys: String, CodingKey {
        case client
        case dev
        case proto
        case remote
        case cipher
        case auth
        case authNocache = "auth-nocache"
        case tlsVersionMin = "tls-version-min"
        case tlsCipher = "tls-cipher"
        case resolvRetry = "resolv-retry"
        case remoteCertTls = "remote-cert-tls"
        case nobind
        case persistKey = "persist-key"
        case muteReplayWarnings = "mute-replay-warnings"
        case verb
        case ca
        case cert
        case key
        case tlsCrypt = "tls-crypt"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let _client = try? values.decode(String.self, forKey: .client) {
            client = _client
        } else {
            client = ""
        }
        
        if let _dev = try? values.decode(String.self, forKey: .dev) {
            dev = _dev
        } else {
            dev = ""
        }
        
        if let _proto = try? values.decode(String.self, forKey: .proto) {
            proto = _proto
        } else {
            proto = ""
        }
        
        if let _remote = try? values.decode(String.self, forKey: .remote) {
            remote = _remote
        } else {
            remote = ""
        }
        
        if let _cipher = try? values.decode(String.self, forKey: .cipher) {
            cipher = _cipher
        } else {
            cipher = ""
        }
        
        if let _auth = try? values.decode(String.self, forKey: .auth) {
            auth = _auth
        } else {
            auth = ""
        }
        
        if let _authNocache = try? values.decode(String.self, forKey: .authNocache) {
            authNocache = _authNocache
        } else {
            authNocache = ""
        }
        
        if let _tlsVersionMin = try? values.decode(String.self, forKey: .tlsVersionMin) {
            tlsVersionMin = _tlsVersionMin
        } else {
            tlsVersionMin = ""
        }
        
        if let _tlsCipher = try? values.decode(String.self, forKey: .tlsCipher) {
            tlsCipher = _tlsCipher
        } else {
            tlsCipher = ""
        }
        
        if let _resolvRetry = try? values.decode(String.self, forKey: .resolvRetry) {
            resolvRetry = _resolvRetry
        } else {
            resolvRetry = ""
        }
        
        if let _remoteCertTls = try? values.decode(String.self, forKey: .remoteCertTls) {
            remoteCertTls = _remoteCertTls
        } else {
            remoteCertTls = ""
        }
        
        if let _nobind = try? values.decode(String.self, forKey: .nobind) {
            nobind = _nobind
        } else {
            nobind = ""
        }
        
        if let _persistKey = try? values.decode(String.self, forKey: .persistKey) {
            persistKey = _persistKey
        } else {
            persistKey = ""
        }
        
        if let _muteReplayWarnings = try? values.decode(String.self, forKey: .muteReplayWarnings) {
            muteReplayWarnings = _muteReplayWarnings
        } else {
            muteReplayWarnings = ""
        }
        
        if let _verb = try? values.decode(Int.self, forKey: .verb) {
            verb = _verb
        } else {
            verb = 0
        }
        
        if let _ca = try? values.decode(String.self, forKey: .ca) {
            ca = _ca
        } else {
            ca = ""
        }
        
        if let _cert = try? values.decode(String.self, forKey: .cert) {
            cert = _cert
        } else {
            cert = ""
        }
        
        if let _key = try? values.decode(String.self, forKey: .key) {
            key = _key
        } else {
            key = ""
        }
        
        if let _tlsCrypt = try? values.decode(String.self, forKey: .tlsCrypt) {
            tlsCrypt = _tlsCrypt
        } else {
            tlsCrypt = ""
        }
    }
}

struct RequestCertificateModel: Codable {
    var server: Server?
    var connectionDetails: ConnectionDetails?
    var requestId: String?
    var sessionId: String?
    
    enum CodingKeys: String, CodingKey {
        case server
        case connectionDetails
        case requestId
        case sessionId
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let _server = try? values.decode(Server.self, forKey: .server) {
            server = _server
        } else {
            server = nil
        }
        
        if let _connectionDetails = try? values.decode(ConnectionDetails.self, forKey: .connectionDetails) {
            connectionDetails = _connectionDetails
        } else {
            connectionDetails = nil
        }
        
        if let _requestId = try? values.decode(String.self, forKey: .requestId) {
            requestId = _requestId
        } else {
            requestId = nil
        }
        
        if let _sessionId = try? values.decode(String.self, forKey: .sessionId) {
            sessionId = _sessionId
        } else {
            sessionId = nil
        }
    }
    
    func convertToString() -> String {
        var stringData = "client"
        let spaceLine = "\r\n"
        
        guard let _connection = connectionDetails else {
            return ""
        }
        
        stringData += spaceLine
        stringData += "dev " + _connection.dev + spaceLine
        stringData += "proto " + _connection.proto + spaceLine 
        stringData += "remote " + _connection.remote + spaceLine
        stringData += "cipher " + _connection.cipher + spaceLine
        stringData += "auth " + _connection.auth + spaceLine
        stringData += "auth-nocache " + _connection.authNocache + spaceLine
        stringData += "tls-version-min " + _connection.tlsVersionMin + spaceLine
        stringData += "tls-cipher " + _connection.tlsCipher + spaceLine
        stringData += "resolv-retry " + _connection.resolvRetry + spaceLine
//        stringData += "remote-cert-tls " + _connection.remoteCertTls + spaceLine
        stringData += "nobind " + _connection.nobind + spaceLine
        stringData += "persist-key " + _connection.persistKey + spaceLine
        stringData += "mute-replay-warnings " + _connection.muteReplayWarnings + spaceLine
        stringData += "verb " + "\(_connection.verb)" + spaceLine
        stringData += "<ca>" + spaceLine + _connection.ca.replacingOccurrences(of: "\n", with: "\r\n") + spaceLine + "</ca>" + spaceLine
        stringData += "<cert>" + spaceLine + _connection.cert.replacingOccurrences(of: "\n", with: "\r\n") + spaceLine + "</cert>" + spaceLine
        stringData += "<key>" + spaceLine + _connection.key.replacingOccurrences(of: "\n", with: "\r\n") + spaceLine + "</key>" + spaceLine
        stringData += "<tls-crypt>" + spaceLine + _connection.tlsCrypt.replacingOccurrences(of: "\n", with: "\r\n") + spaceLine + "</tls-crypt>" + spaceLine
        return stringData
    }
}
