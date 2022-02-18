//
//  Settings.swift
//  SysVPN
//
//  Created by Da Phan Van on 14/01/2022.
//

import Foundation

struct DataSection: Equatable, Identifiable {
    var id: UUID = UUID()
    var type: SectionType
}

struct ItemCell: Equatable, Identifiable {
    var id: UUID = UUID()
    var type: ItemCellType
    var content = ""
}

enum SectionType: Decodable {
    
    case myAccount
    case helpSupport
    
    case vpnSetting
    case otherSetting
    
    case autoConnect
    case typeAutoConnect
    
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
                ItemCell(type: .general)
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
        }
    }
    
    var title: String {
        switch self {
        case .myAccount:
            return LocalizedStringKey.Account.sectionAccount.localized
        case .helpSupport:
            return LocalizedStringKey.Account.sectionSupport.localized
        case .vpnSetting:
            return LocalizedStringKey.Settings.sectionVPN.localized
        case .otherSetting:
            return LocalizedStringKey.Settings.sectionOther.localized
        case .autoConnect:
            return LocalizedStringKey.VPNSetting.sectionAuto.localized
        case .typeAutoConnect:
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
    
    var title: String {
        switch self {
        case .paymentHistory:
            return LocalizedStringKey.AccountStatus.paymentHistory.localized
        case .statusAccount:
            return LocalizedStringKey.Account.itemAccount.localized + " " + AppSetting.shared.statusAccoutn
        case .totalDevice:
            return LocalizedStringKey.Account.itemDevices.localized + ": \(AppSetting.shared.currentNumberDevice)/\(AppSetting.shared.totalNumberDevices)"
        case .questions:
            return LocalizedStringKey.Account.itemQuestions.localized
        case .helpCenter:
            return LocalizedStringKey.Account.itemHelpCenter.localized
        case .security:
            return LocalizedStringKey.Account.itemSecurity.localized
        case .vpnConnection:
            return LocalizedStringKey.Settings.itemVPN.localized
        case .tools:
            return LocalizedStringKey.Settings.itemTool.localized
        case .general:
            return LocalizedStringKey.Settings.itemGeneral.localized
        case .apps:
            return LocalizedStringKey.Settings.itemApps.localized
        case .protection:
            return LocalizedStringKey.Settings.itemProtec.localized
        case .help:
            return LocalizedStringKey.Settings.itemHelp.localized
        case .autoConnet:
            return LocalizedStringKey.VPNSetting.itemAuto.localized
        case .protocolConnect:
            return LocalizedStringKey.VPNSetting.itemProtocol.localized
        case .split:
            return LocalizedStringKey.VPNSetting.itemSplit.localized
        case .dns:
            return LocalizedStringKey.VPNSetting.itemDNS.localized
        case .localNetwork:
            return LocalizedStringKey.VPNSetting.itemLocalNetwork.localized
        case .metered:
            return LocalizedStringKey.VPNSetting.itemMetered.localized
        case .always:
            return LocalizedStringKey.VPNSetting.itemAlways.localized
        case .onWifi:
            return LocalizedStringKey.VPNSetting.itemOnWifi.localized
        case .onMobile:
            return LocalizedStringKey.VPNSetting.itemOnMobile.localized
        case .off:
            return LocalizedStringKey.VPNSetting.itemOff.localized
        case .faster:
            return LocalizedStringKey.VPNSetting.itemFaster.localized
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
            return AppSetting.shared.getDateMemberSince()
        case .paymentHistory:
            return LocalizedStringKey.AccountStatus.tapToShow.localized
        case .totalDevice:
            return LocalizedStringKey.Account.contentTotalDevices.localized
        case .vpnConnection:
            return "6 " + LocalizedStringKey.Settings.settings.localized
        case .general:
            return "3 " + LocalizedStringKey.Settings.settings.localized
        case .apps:
            return AppSetting.shared.appShourtcuts ? LocalizedStringKey.Settings.enabled.localized : LocalizedStringKey.Settings.disabled.localized
        case .protection:
            return AppSetting.shared.protection ? LocalizedStringKey.Settings.enabled.localized : LocalizedStringKey.Settings.disabled.localized
        case .help:
            return AppSetting.shared.help ? LocalizedStringKey.Settings.enabled.localized : LocalizedStringKey.Settings.disabled.localized
        case .autoConnet:
            return AppSetting.shared.autoConnect ? LocalizedStringKey.Global.on.localized : LocalizedStringKey.Global.off.localized
        case .protocolConnect:
            return LocalizedStringKey.VPNSetting.contentItemProtocol.localized
        case .split:
            return LocalizedStringKey.VPNSetting.contentItemSplit.localized
        case .dns:
            return LocalizedStringKey.Global.stateDefault.localized
        case .localNetwork:
            return LocalizedStringKey.VPNSetting.contentItemLocalNetwork.localized
        case .metered:
            return LocalizedStringKey.VPNSetting.contentItemMetered.localized
        case .faster:
            return LocalizedStringKey.VPNSetting.contentItemRecommend.localized
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
        default:
            return false
        }
    }
}
