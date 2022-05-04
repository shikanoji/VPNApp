//
//  NetworkManager.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 20/04/2022.
//

import Foundation
import UIKit

class NetworkManager: ObservableObject {
    
    static var shared = NetworkManager()
    
    enum ConfigVPN {
        case openVPN
        case wireguard
        
        var description: String {
            switch self {
            case .openVPN:
                return "ovpn"
            case .wireguard:
                return "wg"
            }
        }
    }
    
    enum ProtocolVPN {
        case udp
        case tcp
        
        var description: String {
            switch self {
            case .udp:
                return "udp"
            case .tcp:
                return "tcp"
            }
        }
    }
    
    var protocolVPN: ProtocolVPN = .tcp
    
    var selectConfig: ConfigVPN = .wireguard
    
    var requestCertificate: RequestCertificateModel?
    
    var obtainCertificate: ObtainCertificateModel?
    
    var selectNode: Node?
    
    var selectStaticServer: StaticServer?
    
    func connect() {
        switch selectConfig {
        case .openVPN:
            OpenVPNManager.shared.connect()
        case .wireguard:
            WireGuardManager.shared.connect()
        }
    }
    
    func disconnect() {
        switch selectConfig {
        case .openVPN:
            OpenVPNManager.shared.disconnect()
        case .wireguard:
            WireGuardManager.shared.disconnect()
        }
    }
    
    func changeSelectConfig() {
        
    }
    
    func getBandWithInternet() {
        
    }
    
    func testSpeed()  {
        let url = URL(string: "http://my_image_on_web_server.jpg")
        let request = URLRequest(url: url!)
        
        let session = URLSession.shared
        
        let startTime = Date()
        
        let task =  session.dataTask(with: request) { (data, resp, error) in
            
            guard error == nil && data != nil else{
                
                print("connection error or data is nill")
                
                return
            }
            
            guard resp != nil else{
                
                print("respons is nill")
                return
            }
            
            let length  = CGFloat( (resp?.expectedContentLength)!) / 1000000.0
            
            print(length)
            
            
            
            let elapsed = CGFloat( Date().timeIntervalSince(startTime))
            
            print("elapsed: \(elapsed)")
            
            print("Speed: \(length/elapsed) Mb/sec")
            
        }
        
        task.resume()
    }
}
