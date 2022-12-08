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

    func getCert() {
        os_log("GetCertService: Start")
        if let url = URL(string: Constant.api.root + Constant.api.path.requestCertificate) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"

            if let httpBody = try? JSONSerialization.data(withJSONObject: AppSetting.shared.paramGetCert, options: []) {
                urlRequest.httpBody = httpBody
            }

            urlRequest.allHTTPHeaderFields = AppSetting.shared.headerGetCert

            let session = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                os_log("GetCertService: Success")
                if let data = data {
                    os_log("GetCertService: data %{public}s", "\(data)")
                }

                if let error = error {
                    os_log("GetCertService: error %{public}s", "\(error)")
                }
            }

            session.resume()
        }
        os_log("GetCertService: End")
    }
}
