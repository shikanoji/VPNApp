//
//  Settings.swift
//  SysVPN
//
//  Created by Da Phan Van on 14/01/2022.
//

import Foundation
import SwiftDate

struct DataSection: Equatable, Identifiable {
    var id: UUID = UUID()
    var type: SectionType
}

struct ItemCell: Equatable, Identifiable {
    var id: UUID = UUID()
    var type: ItemCellType
    var content = ""
    var select = false
}

enum SectionType: Decodable {
    
    case myAccount
    case helpSupport
    
    case vpnSetting
    case otherSetting
    
    case autoConnect
    case typeAutoConnect
    case protocolConnect
    
    var items: [ItemCell] {
        switch self {
        case .myAccount:
            return [
                ItemCell(type: .statusAccount),
                ItemCell(type: .totalDevice)
            ]
        case .helpSupport:
            return [
                ItemCell(type: .questions),
                ItemCell(type: .helpCenter),
                ItemCell(type: .security)
            ]
        case .vpnSetting:
            return [
                ItemCell(type: .vpnConnection),
                ItemCell(type: .tools),
                //ItemCell(type: .general)
            ]
        case .otherSetting:
            return [
                ItemCell(type: .apps),
                ItemCell(type: .protection),
                ItemCell(type: .help)
            ]
        case .typeAutoConnect:
            return [
                ItemCell(type: .always),
                ItemCell(type: .onWifi),
                ItemCell(type: .onMobile),
                ItemCell(type: .off),
            ]
        case .autoConnect:
            return [
                ItemCell(type: .faster)
            ]
            
        case .protocolConnect:
            return [
                ItemCell(type: .recommend),
                ItemCell(type: .openVPN),
                ItemCell(type: .wireGuard)
            ]
        }
    }
    
    var title: String {
        switch self {
        case .myAccount:
            return L10n.Account.account
        case .helpSupport:
            return L10n.Account.support
        case .vpnSetting:
            return L10n.Settings.sectionVPN
        case .otherSetting:
            return L10n.Settings.sectionOther
        case .autoConnect:
            return L10n.Settings.sectionAutoConnect
        case .typeAutoConnect:
            return ""
        default:
            return ""
        }
    }
}

enum ItemCellType: Decodable {
    case statusAccount
    case totalDevice
    case questions
    case helpCenter
    case security
    case paymentHistory
    case vpnConnection
    case tools
    case general
    case apps
    case protection
    case help
    
    case autoConnet
    case protocolConnect
    case split
    case dns
    case localNetwork
    case metered
    
    case always
    case onWifi
    case onMobile
    case off
    case faster
    
    case recommend
    case openVPN
    case wireGuard
    
    var title: String {
        switch self {
        case .paymentHistory:
            return L10n.Account.AccountStatus.paymentHistory
        case .statusAccount:
            return L10n.Account.itemAccount + " " + (AppSetting.shared.isPremium ? L10n.Account.premium : L10n.Account.freePlan)
        case .totalDevice:
            return L10n.Account.itemDevices + ": \(AppSetting.shared.currentNumberDevice)/\(AppSetting.shared.totalNumberDevices)"
        case .questions:
            return L10n.Account.itemQuestions
        case .helpCenter:
            return L10n.Account.itemHelpCenter
        case .security:
            return L10n.Account.itemSecurity
        case .vpnConnection:
            return L10n.Settings.itemVPN
        case .tools:
            return L10n.Settings.itemTool
        case .general:
            return L10n.Settings.itemGeneral
        case .apps:
            return L10n.Settings.itemApps
        case .protection:
            return L10n.Settings.itemProtec
        case .help:
            return L10n.Settings.itemHelp
        case .autoConnet:
            return L10n.Settings.itemAuto
        case .protocolConnect:
            return L10n.Settings.itemProtocol
        case .split:
            return L10n.Settings.itemSplit
        case .dns:
            return L10n.Settings.itemDNS
        case .localNetwork:
            return L10n.Settings.itemLocalNetwork
        case .metered:
            return L10n.Settings.itemPMetered
        case .always:
            return L10n.Settings.alwaysConnect
        case .onWifi:
            return L10n.Settings.onWifiConnect
        case .onMobile:
            return L10n.Settings.onMobileConnect
        case .off:
            return L10n.Settings.offConnect
        case .faster:
            return L10n.Settings.fastestConnect
        case .recommend:
            return L10n.Settings.contentRecommend
        case .openVPN:
            return L10n.Settings.openVPN
        case .wireGuard:
            return L10n.Settings.wireGuard
        }
    }
    
    var iconString: String {
        switch self {
        case .statusAccount:
            return "icon_account_item_account"
        case .totalDevice:
            return "icon_account_item_device"
        case .questions:
            return "icon_account_item_question"
        case .helpCenter:
            return "icon_account_item_helpCenter"
        case .security:
            return "icon_account_item_security"
        case .vpnConnection:
            return "icon_settings_item_vpn"
        case .tools:
            return "icon_settings_item_tools"
        case .general:
            return "icon_settings_item_general"
        case .apps:
            return "icon_settings_item_apps"
        case .protection:
            return "icon_settings_item_protec"
        case .help:
            return "icon_settings_item_help"
        default:
            return ""
        }
    }
    
    var content: String {
        switch self {
        case .statusAccount:
            guard AppSetting.shared.isPremium else {
                return L10n.Account.premiumOffer
            }
            return "\(L10n.Account.expire) \(AppSetting.shared.premiumExpireDate)"
        case .paymentHistory:
            return L10n.Account.AccountStatus.tapToShow
        case .totalDevice:
            return L10n.Account.contentTotalDevices
        case .vpnConnection:
            return "6 " + L10n.Settings.settings
        case .general:
            return "3 " + L10n.Settings.settings
        case .apps:
            return AppSetting.shared.appShourtcuts ? L10n.Settings.enabled : L10n.Settings.disabled
        case .protection:
            return AppSetting.shared.protection ? L10n.Settings.enabled : L10n.Settings.disabled
        case .help:
            return AppSetting.shared.help ? L10n.Settings.enabled : L10n.Settings.disabled
        case .autoConnet:
            return AppSetting.shared.autoConnect ? L10n.Global.on : L10n.Global.off
        case .protocolConnect:
            return L10n.Settings.contentItemProtocol
        case .split:
            return L10n.Settings.contentItemSplit
        case .dns:
            return AppSetting.shared.dnsSetting == .system ? L10n.Settings.Dns.default : L10n.Settings.Dns.custom
        case .localNetwork:
            return L10n.Settings.contentItemLocalNetwork
        case .metered:
            return L10n.Settings.contentItemMetered
        case .faster:
            return L10n.Settings.contentRecommend
        default:
            return ""
        }
    }
    
    var showRightButton: Bool {
        switch self {
        case .paymentHistory:
            return true
        case .faster:
            return true
        default:
            return false
        }
    }
    
    var showSwitch: Bool {
        switch self {
        case .localNetwork:
            return true
        case .metered:
            return true
//        case .always, .onWifi, .onMobile, .off:
//            return true
        default:
            return false
        }
    }
    
    var showSelect: Bool {
        switch self {
        case .always, .onWifi, .onMobile, .off:
            return true
        case .recommend, .openVPN, .wireGuard:
            return true
        default:
            return false
        }
    }
}
