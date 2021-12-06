//
//  LocalizedStrings.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 06/12/2021.
//

import Foundation

struct LocalizedStringKey {
    enum Global: String {
        case slogan = "Global.slogan"
        
        var localized: String {
            return NSLocalizedString(self.rawValue, tableName: "Localizations", comment: "")
        }
    }
}


