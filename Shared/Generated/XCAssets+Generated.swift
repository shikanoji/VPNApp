// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Assets {
    internal static let accentColor = ColorAsset(name: "AccentColor")
    internal static let iconAccountItemAccount = ImageAsset(name: "icon_account_item_account")
    internal static let iconAccountItemDevice = ImageAsset(name: "icon_account_item_device")
    internal static let iconAccountItemHelpCenter = ImageAsset(name: "icon_account_item_helpCenter")
    internal static let iconAccountItemQuestion = ImageAsset(name: "icon_account_item_question")
    internal static let iconAccountItemSecurity = ImageAsset(name: "icon_account_item_security")
    internal static let iconBoardCity = ImageAsset(name: "icon_board_city")
    internal static let iconBoardDownSpeed = ImageAsset(name: "icon_board_down_speed")
    internal static let iconBoardUpSpeed = ImageAsset(name: "icon_board_up_speed")
    internal static let iconConnectedBoard = ImageAsset(name: "icon_connected_board")
    internal static let iconLocationDefaultBoard = ImageAsset(name: "icon_location_default_board")
    internal static let iconMultihopExit = ImageAsset(name: "icon_multihop_exit")
    internal static let iconMultihopWhat = ImageAsset(name: "icon_multihop_what")
    internal static let iconRemove = ImageAsset(name: "icon_remove")
    internal static let iconSettingBack = ImageAsset(name: "icon_setting_back")
    internal static let iconSettingBoard = ImageAsset(name: "icon_setting_board")
    internal static let iconSettingItemLeft = ImageAsset(name: "icon_setting_item_left")
    internal static let iconSettingItemRight = ImageAsset(name: "icon_setting_item_right")
    internal static let iconSettingItemUp = ImageAsset(name: "icon_setting_item_up")
    internal static let iconSettingProfile = ImageAsset(name: "icon_setting_profile")
    internal static let iconSettingRightConnect = ImageAsset(name: "icon_setting_right_connect")
    internal static let iconStatic = ImageAsset(name: "icon_static")
    internal static let iconUserBoard = ImageAsset(name: "icon_user_board")
    internal static let japan = ImageAsset(name: "japan")
    internal static let loading = ImageAsset(name: "loading")
    internal static let logoConnected = ImageAsset(name: "logo_connected")
    internal static let logoConnectedBackground = ImageAsset(name: "logo_connected_background")
    internal static let map = ImageAsset(name: "map")
    internal static let checkmark = ImageAsset(name: "Checkmark")
    internal static let introduction1 = ImageAsset(name: "Introduction-1")
    internal static let introduction2 = ImageAsset(name: "Introduction-2")
    internal static let introduction3 = ImageAsset(name: "Introduction-3")
    internal static let lock = ImageAsset(name: "Lock")
    internal static let launchScreen = ImageAsset(name: "LaunchScreen")
    internal static let apple = ImageAsset(name: "apple")
    internal static let google = ImageAsset(name: "google")
    internal static let logoMedium = ImageAsset(name: "Logo-medium")
    internal static let logoSmall = ImageAsset(name: "Logo-small")
    internal static let iconCheckbox = ImageAsset(name: "icon_checkbox")
    internal static let iconSettingsItemApps = ImageAsset(name: "icon_settings_item_apps")
    internal static let iconSettingsItemGeneral = ImageAsset(name: "icon_settings_item_general")
    internal static let iconSettingsItemHelp = ImageAsset(name: "icon_settings_item_help")
    internal static let iconSettingsItemLicense = ImageAsset(name: "icon_settings_item_license")
    internal static let iconSettingsItemPrivacy = ImageAsset(name: "icon_settings_item_privacy")
    internal static let iconSettingsItemProtec = ImageAsset(name: "icon_settings_item_protec")
    internal static let iconSettingsItemTerm = ImageAsset(name: "icon_settings_item_term")
    internal static let iconSettingsItemTools = ImageAsset(name: "icon_settings_item_tools")
    internal static let iconSettingsItemVersion = ImageAsset(name: "icon_settings_item_version")
    internal static let iconSettingsItemVpn = ImageAsset(name: "icon_settings_item_vpn")
    internal static let iconUncheck = ImageAsset(name: "icon_uncheck")
    internal static let subscriptionIntroImage = ImageAsset(name: "Subscription-Intro-Image")
    internal static let accountLinked = ImageAsset(name: "account-linked")
    internal static let cashReturn = ImageAsset(name: "cash-return")
    internal static let close = ImageAsset(name: "close")
    internal static let liveSupport = ImageAsset(name: "live-support")
    internal static let logout = ImageAsset(name: "logout")
    internal static let redLinearGradient = ImageAsset(name: "red-linear-gradient")
    internal static let rocketFast = ImageAsset(name: "rocket-fast")
    internal static let unlimited = ImageAsset(name: "unlimited")
    internal static let welcome = ImageAsset(name: "welcome")
    internal static let fastestServerIcon = ImageAsset(name: "fastest_server_icon")
    internal static let iconArrowRight = ImageAsset(name: "icon_arrow_right")
  }
  internal enum Colors {
    internal static let vpnConnected = ColorAsset(name: "VPNConnected")
    internal static let vpnUnconnected = ColorAsset(name: "VPNUnconnected")
    internal static let background = ColorAsset(name: "background")
    internal static let backgroundCity = ColorAsset(name: "backgroundCity")
    internal static let backgroundLoading = ColorAsset(name: "backgroundLoading")
    internal static let backgroundStatusView = ColorAsset(name: "backgroundStatusView")
    internal static let blackText = ColorAsset(name: "blackText")
    internal static let borderSearch = ColorAsset(name: "borderSearch")
    internal static let darkButton = ColorAsset(name: "darkButton")
    internal static let darkThemeColor = ColorAsset(name: "darkThemeColor")
    internal static let green = ColorAsset(name: "green")
    internal static let greenGradient = ColorAsset(name: "greenGradient")
    internal static let leftCircle = ColorAsset(name: "leftCircle")
    internal static let lightBlack = ColorAsset(name: "lightBlack")
    internal static let lightBlackText = ColorAsset(name: "lightBlackText")
    internal static let lightGray = ColorAsset(name: "lightGray")
    internal static let navigationBar = ColorAsset(name: "navigationBar")
    internal static let pink = ColorAsset(name: "pink")
    internal static let planListCellDeactiveBackground = ColorAsset(name: "planListCellDeactiveBackground")
    internal static let redGradient = ColorAsset(name: "redGradient")
    internal static let rightCircle = ColorAsset(name: "rightCircle")
    internal static let toastBackground = ColorAsset(name: "toastBackground")
    internal static let whiteStatus = ColorAsset(name: "whiteStatus")
    internal static let yellowGradient = ColorAsset(name: "yellowGradient")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
