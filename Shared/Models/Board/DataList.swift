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
    var select = false
    var alert = ""
}

struct SectionCell: Equatable, Identifiable {
    var id: UUID = UUID()
    var type: SectionType
    var items: [ItemCell] = []
    
    init(_ type: SectionType) {
        self.type = type
        self.items = type.items
    }
    
    mutating func updateSelectedItemListAndUnSelectOther(_ cell: ItemCell) {
        items = items.map {
            var updateItem = $0
            updateItem.select = cell.type == $0.type
            return updateItem
        }
    }
    
    mutating func updateItem(_ item: ItemCell) {
        items = items.map {
            return $0.type == item.type ? item : $0
        }
    }
}

enum SectionType: Decodable {
    
    case myAccount
    case helpSupport
    
    case tools
    
    case vpnSetting
    case otherSetting
    
    case autoConnect
    case typeAutoConnect
    case protocolConnect
    
    case infomation
    
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
                ItemCell(type: .fastestServer)
            ]
            
        case .protocolConnect:
            return [
                ItemCell(type: .recommend),
                ItemCell(type: .wireGuard),
                ItemCell(type: .openVPNTCP),
                ItemCell(type: .openVPNUDP)
            ]
            
        case .tools:
            return [
                ItemCell(type: .cyberSec)
//                ,ItemCell(type: .killSwitch)
//                ,ItemCell(type: .darkWebMonitor)
//                ,ItemCell(type: .tapJacking)
            ]
            
        case .infomation:
            return [
                ItemCell(type: .email),
                ItemCell(type: .joinMember),
                ItemCell(type: .sysVPNId),
                ItemCell(type: .accountSecurity),
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

enum ItemCellType: Int, Decodable {
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
    
    case autoConnect
    case protocolConnect
    case split
    case dns
    case localNetwork
    case metered
    
    case always
    case onWifi
    case onMobile
    case off
    case fastestServer
    
    case recommend
    case openVPNTCP
    case openVPNUDP
    case wireGuard
    
    case cyberSec
    case killSwitch
    case darkWebMonitor
    case tapJacking
    
    case email
    case joinMember
    case sysVPNId
    case accountSecurity
    
    var title: String {
        switch self {
        case .email:
            return L10n.Account.Infomation.email
        case .joinMember:
            return L10n.Account.Infomation.member
        case .sysVPNId:
            return L10n.Account.Infomation.id
        case .accountSecurity:
            return L10n.Account.Infomation.security
        case .cyberSec:
            return L10n.Settings.Tools.cyberSec
        case .killSwitch:
            return L10n.Settings.Tools.killSwitch
        case .darkWebMonitor:
            return L10n.Settings.Tools.darkWebMonitors
        case .tapJacking:
            return L10n.Settings.Tools.tapJackingProtection
        case .paymentHistory:
            return L10n.Account.AccountStatus.paymentHistory
        case .statusAccount:
            return L10n.Account.itemAccount + " " + (AppSetting.shared.isPremium ? L10n.Account.premium : L10n.Account.freePlan)
        case .totalDevice:
            return L10n.Account.itemDevices + ": \(AppSetting.shared.currentNumberDevice)/\(AppSetting.shared.maxNumberDevices)"
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
        case .autoConnect:
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
        case .fastestServer:
            if let autoConnectNode = AppSetting.shared.getAutoConnectNode() {
                return autoConnectNode.countryName
            }
            return L10n.Settings.fastestConnect
        case .recommend:
            return L10n.Settings.contentRecommend
        case .openVPNTCP:
            return L10n.Settings.openVPNTCP
        case .openVPNUDP:
            return L10n.Settings.openVPNUDP
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
        case .email:
            return AppSetting.shared.email
        case .joinMember:
            return AppSetting.shared.joinedDate?.toFormat("dd-MM-yyyy") ?? ""
        case .sysVPNId:
            return AppSetting.shared.idVPN
        case .accountSecurity:
            return L10n.Account.Infomation.tapToChangePassword
            
        case .cyberSec:
            return L10n.Settings.Tools.CyberSec.note
        case .killSwitch:
            return L10n.Settings.Tools.KillSwitch.note
        case .darkWebMonitor:
            return L10n.Settings.Tools.DarkWebMonitors.note
        case .tapJacking:
            return L10n.Settings.Tools.TapJackingProtection.note
        case .statusAccount:
            guard AppSetting.shared.isPremium else {
                return L10n.Account.premiumOffer
            }
            return "\(L10n.Account.expire) \(AppSetting.shared.premiumExpireDate?.toFormat("dd-MM-yyyy") ?? "")"
        case .paymentHistory:
            return L10n.Account.AccountStatus.tapToShow
        case .totalDevice:
            return L10n.Account.contentTotalDevices
        case .vpnConnection:
            return "3 " + L10n.Settings.settings
        case .general:
            return "3 " + L10n.Settings.settings
        case .apps:
            return AppSetting.shared.appShourtcuts ? L10n.Settings.enabled : L10n.Settings.disabled
        case .protection:
            return AppSetting.shared.protection ? L10n.Settings.enabled : L10n.Settings.disabled
        case .help:
            return AppSetting.shared.help ? L10n.Settings.enabled : L10n.Settings.disabled
        case .autoConnect:
            return AppSetting.shared.getAutoConnectProtocol().title
        case .protocolConnect:
            return AppSetting.shared.getConfigProtocol().title
        case .split:
            return L10n.Settings.contentItemSplit
        case .dns:
            return AppSetting.shared.getContentDNSCell()
        case .localNetwork:
            return L10n.Settings.contentItemLocalNetwork
        case .metered:
            return L10n.Settings.contentItemMetered
        case .fastestServer:
            if let autoConnectNode = AppSetting.shared.getAutoConnectNode() {
                return autoConnectNode.name 
            }
            return L10n.Settings.contentRecommend
        default:
            return ""
        }
    }
    
    var showRightButton: Bool {
        switch self {
        case .paymentHistory:
            return true
        case .fastestServer:
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
        case .cyberSec:
            return true
        default:
            return false
        }
    }
    
    var showSelect: Bool {
        switch self {
        case .always, .onWifi, .onMobile, .off:
            return true
        case .recommend, .openVPNTCP, .openVPNUDP, .wireGuard:
            return true
        default:
            return false
        }
    }
}
