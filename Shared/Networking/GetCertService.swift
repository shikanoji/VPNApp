//
//  GetCertService.swift
//  SysVPN
//
//  Created by Da Phan Van on 08/12/2022.
//

import Foundation
import UIKit
import OSLog

class GetCertService {
    static var shared = GetCertService()
    
    func getObtainCert(param: [String: Any],
                       header: [String: String],
                       _ completion: @escaping (ObtainCertificateModel?) -> Void) {
        if var url = URL(string: Constant.api.root + Constant.api.path.requestCertificate) {
            
            let components = NSURLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = getURLQueryItems(for: param)
            
            guard let componentUrl = components?.url else {
                completion(nil)
                return
            }
            
            var urlRequest = URLRequest(url: componentUrl)
            urlRequest.httpMethod = "GET"
            
            urlRequest.allHTTPHeaderFields = header
            
            let session = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let data = data {
                    do {
                        let responseT = try JSONDecoder().decode(APIResponse<ObtainCertificateModel>.self, from: data)
                        completion(responseT.result)
                    } catch {
                        completion(nil)
                        return
                    }
                }
                
                if let error = error {
                    os_log("GetCertService: error %{public}s", "\(error)")
                    completion(nil)
                    return
                }
            }
            
            session.resume()
        } else {
            completion(nil)
            return
        }
    }
    
    func getCert(param: [String: Any],
                 header: [String: String],
                 _ completion: @escaping (RequestCertificateModel?) -> Void) {
        if var url = URL(string: Constant.api.root + Constant.api.path.requestCertificate) {
            
            let components = NSURLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = getURLQueryItems(for: param)
            
            guard let componentUrl = components?.url else {
                completion(nil)
                return
            }
            
            var urlRequest = URLRequest(url: componentUrl)
            urlRequest.httpMethod = "GET"
            
            urlRequest.allHTTPHeaderFields = header
            
            let session = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let data = data {
                    do {
                        let responseT = try JSONDecoder().decode(APIResponse<RequestCertificateModel>.self, from: data)
                        completion(responseT.result)
                    } catch {
                        completion(nil)
                        return
                    }
                }
                
                if let error = error {
                    os_log("GetCertService: error %{public}s", "\(error)")
                    completion(nil)
                    return
                }
            }
            
            session.resume()
        } else {
            completion(nil)
            return
        }
    }
    
    private func getURLQueryItems(for params: [String: Any?]?) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        for (key, value) in (params ?? [:]) {
            if let value = value {
                queryItems.append(URLQueryItem(name: key, value: "\(value)"))
            }
        }
        return queryItems
    }
}
