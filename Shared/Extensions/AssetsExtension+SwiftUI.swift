//
//  AssetsExtension+SwiftUI.swift
//  SysVPN (iOS)
//
//  Created by Nguyen Dinh Thach on 13/03/2022.
//

import Foundation
import SwiftUI
///Extension for converting SwiftUI Color and Image
extension ColorAsset {
    var SuColor: SwiftUI.Color {
        SwiftUI.Color(color)
    }
}

extension ImageAsset {
    var SuImage: SwiftUI.Image {
        SwiftUI.Image(name)
    }
}
