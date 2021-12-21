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
    
    enum Introduction: String {
        case trialButton = "Introduction.trialButton"
        
        var localized: String {
            return NSLocalizedString(self.rawValue, tableName: "Localizations", comment: "")
        }
    }
    
    enum Login: String {
        case title = "Login.Title"
        case body = "Login.Body"
        
        var localized: String {
            return NSLocalizedString(self.rawValue, tableName: "Localizations", comment: "")
        }
    }
}


