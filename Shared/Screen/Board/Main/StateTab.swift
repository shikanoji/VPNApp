//
//  StateTab.swift
//  SysVPN
//
//  Created by Nguyen Dinh Thach on 05/12/2022.
//

import Foundation
enum StateTab: Int {
    case location = 0
    case staticIP = 1
    case multiHop = 2

    var title: String {
        switch self {
        case .location:
            return L10n.Board.locationTitleTab
        case .staticIP:
            return L10n.Board.staticIPTitleTab
        case .multiHop:
            return L10n.Board.multiHopTitleTab
        }
    }
}
