//
//  TextExtension.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 16/12/2021.
//

import Foundation
import SwiftUI

extension Text {
    func setDefault() -> some View {
        modifier(DefaultLabel())
    }
}
