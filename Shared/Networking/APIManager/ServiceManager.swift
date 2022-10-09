//
//  ServiceManager.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 02/12/2021.
//

import RxSwift
import Moya
import SwiftyJSON
import SwiftUI

final class ServiceManager: BaseServiceManager<APIService> {
    static let shared = ServiceManager()
}

