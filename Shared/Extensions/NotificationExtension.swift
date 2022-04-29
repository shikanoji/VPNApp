//
//  NotificationExtension.swift
//  SysVPN (iOS)
//
//  Created by Nguyen Dinh Thach on 29/04/2022.
//

import Foundation
import UIKit
extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}
