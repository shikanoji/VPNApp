//
//  UIApplicationExtension.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 02/12/2021.
//

import Foundation
import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension UIApplication {
  var currentKeyWindow: UIWindow? {
    UIApplication.shared.connectedScenes
      .filter { $0.activationState == .foregroundActive }
      .map { $0 as? UIWindowScene }
      .compactMap { $0 }
      .first?.windows
      .filter { $0.isKeyWindow }
      .first
  }

  var rootViewController: UIViewController? {
    currentKeyWindow?.rootViewController
  }
}
