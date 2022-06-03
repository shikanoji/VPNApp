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
                selectedValue = .system
                AppSetting.shared.dnsSetting = .system
            } else {
                selectedValue = .custom
                AppSetting.shared.dnsSetting = .custom
            }
        }
    }
    
    @Published var selectedValue: DNSSetting = AppSetting.shared.dnsSetting
    @Published var primaryDNSValue: String = AppSetting.shared.primaryDNSValue
    @Published var secondaryDNSValue: String = AppSetting.shared.secondaryDNSValue
    @Published var showAlert: Bool = false
    var alertTitle: String = ""
    var alertMessage: String = ""
    let validIpAddressRegex = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"
    
    func save() {
        guard !primaryDNSValue.isEmpty, !secondaryDNSValue.isEmpty else {
            alertMessage = "Can not leave DNS empty!"
            showAlert = true
            return
        }
        
        guard [primaryDNSValue, secondaryDNSValue].allSatisfy({ $0.range(of: validIpAddressRegex, options: .regularExpression) != nil }) else {
            alertMessage = "Invalid DNS format!"
            showAlert = true
            return
        }
        
        AppSetting.shared.primaryDNSValue = primaryDNSValue
        AppSetting.shared.secondaryDNSValue = secondaryDNSValue
        alertMessage = L10n.Global.saveSuccess
        showAlert = true
    }
}
