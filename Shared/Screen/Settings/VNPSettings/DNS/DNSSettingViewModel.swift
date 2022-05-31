//
//  DNSSettingViewModel.swift
//  SysVPN (iOS)
//
//  Created by Nguyen Dinh Thach on 30/05/2022.
//

import Foundation

class DNSSettingViewModel: ObservableObject {
    @Published var selectedDefaultDns: Bool = AppSetting.shared.dnsSetting == .system {
        didSet {
            if selectedDefaultDns {
                selectedCustomDns = false
                selectedValue = .system
            }
        }
    }
    @Published var selectedCustomDns: Bool = AppSetting.shared.dnsSetting == .custom {
        didSet {
            if selectedCustomDns {
                selectedDefaultDns = false
                selectedValue = .custom
            }
        }
    }
    
    @Published var selectedValue: DNSSetting = AppSetting.shared.dnsSetting
    @Published var customDNSValue: String = AppSetting.shared.customDNSValue
    @Published var showAlert: Bool = false
    var alertTitle: String = ""
    var alertMessage: String = ""
}
