//
//  DateExtension.swift
//  SysVPN
//
//  Created by Da Phan Van on 17/01/2022.
//

import Foundation

extension Date: RawRepresentable {
    private static let formatter = ISO8601DateFormatter()

    public var rawValue: String {
        Date.formatter.string(from: self)
    }

    public init?(rawValue: String) {
        self = Date.formatter.date(from: rawValue) ?? Date()
    }
}
