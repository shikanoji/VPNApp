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
    
    enum Board: String {
        case yourIP = "Board.IP"
        case subIP = "Board.SubIP"
        case unConnect = "Board.Unconnect"
        case connected = "Board.Connected"
        case connecting = "Board.Connecting"
        case titleNavigationNotConnect = "Board.NavigationTitleNotConnect"
        case titleNavigationConnected = "Board.NavigationTitleConnecting"
        case titleNavigationConnecting = "Board.NavigationTitleConnected"
        case locationTitleTab = "Locations"
        case staticIPTab = "Static IP"
        case multiHopTab = "MultiHop"
        case connectButton = "Board.QuickConnect"
        
        var localized: String {
            return NSLocalizedString(self.rawValue, tableName: "Localizations", comment: "")
        }
    }
}


