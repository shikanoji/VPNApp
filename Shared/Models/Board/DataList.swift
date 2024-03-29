//
//  Settings.swift
//  SysVPN
//
//  Created by Da Phan Van on 14/01/2022.
//

import Foundation
import SwiftDate
import SwiftUI

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
        items = type.items
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
            ]
        case .vpnSetting:
            return [
                ItemCell(type: .vpnConnection),
                ItemCell(type: .tools),
            ]
        case .otherSetting:
            return [
                ItemCell(type: .privacyPolicy),
                ItemCell(type: .termAndConditions),
                ItemCell(type: .licenses),
                ItemCell(type: .currentVersion)
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
                ItemCell(type: .recommended),
                ItemCell(type: .wireGuard),
                ItemCell(type: .openVPNTCP),
                ItemCell(type: .openVPNUDP)
            ]
            
        case .tools:
            return [
                ItemCell(type: .cyberSec)
            ]
            
        case .infomation:
            return [
                ItemCell(type: .email),
                ItemCell(type: .joinMember),
//                ItemCell(type: .sysVPNId),
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
    case termAndConditions
    case currentVersion
    case help
    case licenses
    case privacyPolicy
    
    case autoConnect
    case protocolConnect
    case dns
    case localNetwork
    case metered
    
    case always
    case onWifi
    case onMobile
    case off
    case fastestServer
    
    case recommended
    case openVPNTCP
    case openVPNUDP
    case wireGuard
    
    case cyberSec

    case email
    case joinMember
    case accountSecurity
    
    var title: String {
        switch self {
        case .email:
            return L10n.Account.Infomation.email
        case .joinMember:
            return L10n.Account.Infomation.member
        case .accountSecurity:
            return L10n.Account.Infomation.security
        case .cyberSec:
            return L10n.Settings.Tools.cyberSec
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
        case .currentVersion:
            return L10n.Settings.currentVersion
        case .termAndConditions:
            return L10n.Settings.termAndCondition
        case .help:
            return L10n.Settings.itemHelp
        case .autoConnect:
            return L10n.Settings.itemAuto
        case .protocolConnect:
            return L10n.Settings.itemProtocol

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
        case .recommended:
            return L10n.Settings.contentRecommended
        case .openVPNTCP:
            return L10n.Settings.openVPNTCP
        case .openVPNUDP:
            return L10n.Settings.openVPNUDP
        case .wireGuard:
            return L10n.Settings.wireGuard
        case .licenses:
            return L10n.Settings.licenses
        case .privacyPolicy:
            return L10n.Settings.privacyPolicty
        }
    }
    
    var icon: Image? {
        switch self {
        case .statusAccount:
            return Asset.Assets.iconAccountItemAccount.swiftUIImage
        case .totalDevice:
            return Asset.Assets.iconAccountItemDevice.swiftUIImage
        case .questions:
            return Asset.Assets.iconAccountItemQuestion.swiftUIImage
        case .helpCenter:
            return Asset.Assets.iconAccountItemHelpCenter.swiftUIImage
        case .security:
            return Asset.Assets.iconAccountItemSecurity.swiftUIImage
        case .vpnConnection:
            return Asset.Assets.iconSettingsItemVpn.swiftUIImage
        case .tools:
            return Asset.Assets.iconSettingsItemTools.swiftUIImage
        case .currentVersion:
            return Asset.Assets.iconSettingsItemVersion.swiftUIImage
        case .help:
            return Asset.Assets.iconSettingsItemHelp.swiftUIImage
        case .licenses:
            return Asset.Assets.iconSettingsItemLicense.swiftUIImage
        case .termAndConditions:
            return Asset.Assets.iconSettingsItemTerm.swiftUIImage
        case .privacyPolicy:
            return Asset.Assets.iconSettingsItemPrivacy.swiftUIImage
        default:
            return nil
        }
    }
    
    var content: String {
        switch self {
        case .email:
            return AppSetting.shared.email
        case .joinMember:
            return AppSetting.shared.joinedDate?.toFormat("dd-MM-yyyy") ?? ""
        case .accountSecurity:
            return L10n.Account.Infomation.tapToChangePassword
            
        case .cyberSec:
            return L10n.Settings.Tools.CyberSec.note

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
        case .help:
            return AppSetting.shared.help ? L10n.Settings.enabled : L10n.Settings.disabled
        case .autoConnect:
            return AppSetting.shared.getAutoConnectProtocol().title
        case .protocolConnect:
            return AppSetting.shared.getConfigProtocol().title

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
            return L10n.Settings.contentRecommended
        case .currentVersion:
            return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        default:
            return ""
        }
    }
    
    var showRightButton: Bool {
        switch self {
        case .currentVersion, .always, .onWifi, .onMobile, .off, .recommended, .wireGuard, .openVPNTCP, .openVPNUDP:
            return false
        default:
            return true
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
        case .recommended, .openVPNTCP, .openVPNUDP, .wireGuard:
            return true
        default:
            return false
        }
    }
    
    var getConfigParam: String {
        switch self {
        case .openVPNTCP, .recommended, .openVPNUDP:
            return "ovpn"
        case .wireGuard:
            return "wg"
        default:
            return ""
        }
    }
    
    var getProtocolVPN: String {
        switch self {
        case .openVPNTCP:
            return "tcp"
        default:
            return "udp"
        }
    }
}
