//
//  BoardViewModel.swift
//  SysVPN
//
//  Created by Phan Văn Đa on 17/12/2021.
//

import Foundation
import SwiftUI

class BoardViewModel: ObservableObject {
    
    enum StateBoard {
        case error
        case start
        case connected
        
        var title: String {
            switch self {
            case .error:
                return "VPN error"
            case .start:
                return "VPN not connected"
            case .connected:
                return "VPN connected"
            }
        }
        
        var subTitle: String {
            switch self {
            case .error:
                return "Unprotected"
            case .start:
                return "Unprotected"
            case .connected:
                return "Protected"
            }
        }
        
        var subColor: Color {
            switch self {
            case .error, .start:
                return AppColor.VPNUnconnect
            case .connected:
                return AppColor.VPNConnected
            }
        }
    }
    
    @Published var state: StateBoard = .start
    @Published var ip = "199.199.199.8"
}
