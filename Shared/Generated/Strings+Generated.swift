// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  public enum Account {
    /// My Account
    public static let account = L10n.tr("Account", "Account")
    /// Multiple devices online
    public static let contentTotalDevices = L10n.tr("Account", "contentTotalDevices")
    /// Delete your account
    public static let deleteAccount = L10n.tr("Account", "deleteAccount")
    /// Expire on
    public static let expire = L10n.tr("Account", "expire")
    /// Free plan
    public static let freePlan = L10n.tr("Account", "freePlan")
    /// Account status:
    public static let itemAccount = L10n.tr("Account", "itemAccount")
    /// Devices
    public static let itemDevices = L10n.tr("Account", "itemDevices")
    /// Help Center
    public static let itemHelpCenter = L10n.tr("Account", "itemHelpCenter")
    /// Frequently Asked Questions
    public static let itemQuestions = L10n.tr("Account", "itemQuestions")
    /// Sercurity level
    public static let itemSecurity = L10n.tr("Account", "itemSecurity")
    /// Premium
    public static let premium = L10n.tr("Account", "premium")
    /// Premium plan only $3/month
    public static let premiumOffer = L10n.tr("Account", "premiumOffer")
    /// Sign Out
    public static let signout = L10n.tr("Account", "signout")
    /// Help & Support
    public static let support = L10n.tr("Account", "Support")
    /// Tap to control profile
    public static let tapControl = L10n.tr("Account", "tapControl")
    /// Account
    public static let titleAccount = L10n.tr("Account", "titleAccount")
    public enum AccountStatus {
      /// Extend Subscription
      public static let extend = L10n.tr("Account", "AccountStatus.extend")
      /// Joined
      public static let joined = L10n.tr("Account", "AccountStatus.joined")
      /// Payment history
      public static let paymentHistory = L10n.tr("Account", "AccountStatus.paymentHistory")
      /// Tap to show
      public static let tapToShow = L10n.tr("Account", "AccountStatus.tapToShow")
      /// Your Subscription
      public static let title = L10n.tr("Account", "AccountStatus.title")
      /// Premium plan only $3/month
      public static let upgradeToPremium = L10n.tr("Account", "AccountStatus.upgradeToPremium")
    }
    public enum ChangePassword {
      /// Confirm password does not matche
      public static let passwordNotMatch = L10n.tr("Account", "ChangePassword.passwordNotMatch")
      /// Successfully changed password
      public static let success = L10n.tr("Account", "ChangePassword.success")
    }
    public enum DeleteAccount {
      /// Delete
      public static let delete = L10n.tr("Account", "DeleteAccount.delete")
      /// Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
      public static let message = L10n.tr("Account", "DeleteAccount.message")
      /// Note: This action cannot be undone.
      public static let note = L10n.tr("Account", "DeleteAccount.note")
    }
    public enum Infomation {
      /// Change password
      public static let changePassword = L10n.tr("Account", "Infomation.changePassword")
      /// Current Password
      public static let currentPassword = L10n.tr("Account", "Infomation.currentPassword")
      /// Your email
      public static let email = L10n.tr("Account", "Infomation.email")
      /// SysVpn id
      public static let id = L10n.tr("Account", "Infomation.id")
      /// Enter current & new password
      public static let introChangePassword = L10n.tr("Account", "Infomation.introChangePassword")
      /// Member since
      public static let member = L10n.tr("Account", "Infomation.member")
      /// New Password
      public static let newPassword = L10n.tr("Account", "Infomation.newPassword")
      /// Retype New Password
      public static let retypePassword = L10n.tr("Account", "Infomation.retypePassword")
      /// Save
      public static let save = L10n.tr("Account", "Infomation.save")
      /// Account sercurity
      public static let security = L10n.tr("Account", "Infomation.security")
      /// Set password
      public static let setPassword = L10n.tr("Account", "Infomation.setPassword")
      /// Set password for your account.
      public static let setPasswordNote = L10n.tr("Account", "Infomation.setPasswordNote")
      /// Tap to change password
      public static let tapToChangePassword = L10n.tr("Account", "Infomation.tapToChangePassword")
      /// Infomation
      public static let title = L10n.tr("Account", "Infomation.title")
    }
    public enum Logout {
      /// Confirm
      public static let confirm = L10n.tr("Account", "Logout.Confirm")
      public enum Confirm {
        /// Are you sure want to logout?
        public static let message = L10n.tr("Account", "Logout.Confirm.Message")
      }
    }
    public enum PaymentHistory {
      /// Cancel Subscription
      public static let cancelSubscription = L10n.tr("Account", "PaymentHistory.cancelSubscription")
    }
  }
  public enum Board {
    /// Back to maps
    public static let backToMap = L10n.tr("Board", "backToMap")
    /// Protected
    public static let connected = L10n.tr("Board", "Connected")
    /// Connected
    public static let connectedAlert = L10n.tr("Board", "ConnectedAlert")
    /// Connecting..
    public static let connecting = L10n.tr("Board", "Connecting")
    /// Your IP: 
    public static let ip = L10n.tr("Board", "IP")
    /// Locations
    public static let locationTitleTab = L10n.tr("Board", "LocationTitleTab")
    /// MultiHop
    public static let multiHopTitleTab = L10n.tr("Board", "MultiHopTitleTab")
    /// VPN connected
    public static let navigationTitleConnected = L10n.tr("Board", "NavigationTitleConnected")
    /// Connecting...
    public static let navigationTitleConnecting = L10n.tr("Board", "NavigationTitleConnecting")
    /// VPN not connected
    public static let navigationTitleNotConnect = L10n.tr("Board", "NavigationTitleNotConnect")
    /// Quick
    /// Connect
    public static let quickUnConnect = L10n.tr("Board", "QuickUnConnect")
    /// /s
    public static let speed = L10n.tr("Board", "Speed")
    /// Static IP
    public static let staticIPTitleTab = L10n.tr("Board", "StaticIPTitleTab")
    /// Connect to VPN to online sercurity
    public static let subIP = L10n.tr("Board", "SubIP")
    /// Unprotected
    public static let unconnect = L10n.tr("Board", "Unconnect")
    public enum BoardList {
      /// All countries
      public static let allCountries = L10n.tr("Board", "BoardList.AllCountries")
      /// available
      public static let available = L10n.tr("Board", "BoardList.Available")
      /// cities
      public static let cities = L10n.tr("Board", "BoardList.Cities")
      /// city
      public static let city = L10n.tr("Board", "BoardList.City")
      /// City of
      public static let cityOf = L10n.tr("Board", "BoardList.CityOf")
      /// Recent locations
      public static let recentLocations = L10n.tr("Board", "BoardList.RecentLocations")
      /// Recommended
      public static let recommended = L10n.tr("Board", "BoardList.Recommended")
      /// Search
      public static let search = L10n.tr("Board", "BoardList.Search")
      /// Single location
      public static let singleLocation = L10n.tr("Board", "BoardList.SingleLocation")
      public enum MultiHop {
        /// Connect
        public static let connect = L10n.tr("Board", "BoardList.MultiHop.Connect")
        /// A multiHop VPN, also known as a double VPN, works by sending your internet traffic through two secure servers rather than one when you go online. Consider this as a secure tunnel inside a secure tunnel, which provides an extra layer of security. As your data reaches each server, it receives another extra layer of traffic encryption (double-encrypted), to the point where your data is almost entirely inaccessible to cybercriminals, ensuring both your IP and traffic are therefore protected twice as much.
        public static let contentMultiHop = L10n.tr("Board", "BoardList.MultiHop.ContentMultiHop")
        /// Exit location represents your main VPN server
        public static let exit = L10n.tr("Board", "BoardList.MultiHop.Exit")
        /// Got it
        public static let gotIt = L10n.tr("Board", "BoardList.MultiHop.GotIt")
        /// Recent connections
        public static let recentConnections = L10n.tr("Board", "BoardList.MultiHop.RecentConnections")
        /// Select entry location
        public static let selectEntryLocation = L10n.tr("Board", "BoardList.MultiHop.SelectEntryLocation")
        /// Select exit location
        public static let selectExitLocation = L10n.tr("Board", "BoardList.MultiHop.SelectExitLocation")
        /// What is multihop?
        public static let what = L10n.tr("Board", "BoardList.MultiHop.What")
      }
    }
  }
  public enum Faq {
    /// About SysVPN
    public static let aboutSysvpn = L10n.tr("FAQ", "aboutSysvpn")
    /// SysVPN Subscriptions
    public static let sysvpnSubscription = L10n.tr("FAQ", "sysvpnSubscription")
    /// Frequently Asked Questions
    public static let title = L10n.tr("FAQ", "title")
    /// VPN Basic
    public static let vpnbasic = L10n.tr("FAQ", "vpnbasic")
  }
  public enum ForgotPassword {
    /// It's great to see you back
    public static let body = L10n.tr("ForgotPassword", "Body")
    /// Your email
    public static let emailPlaceholder = L10n.tr("ForgotPassword", "EmailPlaceholder")
    /// Send request
    public static let sendRequestButton = L10n.tr("ForgotPassword", "SendRequestButton")
    /// Successfully sent request. Pleae check your e-mail for confirmation.
    public static let success = L10n.tr("ForgotPassword", "Success")
    /// Forgot Password
    public static let title = L10n.tr("ForgotPassword", "Title")
  }
  public enum Global {
    /// Back
    public static let back = L10n.tr("Global", "Back")
    /// Cancel
    public static let cancel = L10n.tr("Global", "cancel")
    /// Default
    public static let `default` = L10n.tr("Global", "default")
    /// Error
    public static let error = L10n.tr("Global", "Error")
    /// Off
    public static let off = L10n.tr("Global", "off")
    /// OK
    public static let ok = L10n.tr("Global", "ok")
    /// On
    public static let on = L10n.tr("Global", "on")
    /// Saved successfully!
    public static let saveSuccess = L10n.tr("Global", "SaveSuccess")
    /// Light is Faster, but We are Safer
    public static let slogan = L10n.tr("Global", "slogan")
    /// Something went wrong
    public static let somethingWrong = L10n.tr("Global", "SomethingWrong")
  }
  public enum Introduction {
    /// SysVPN brings top-notch security by encrypting your connection, masking your sensitive info, and disguising your online activities from hacker attacks.
    public static let intro1Body = L10n.tr("Introduction", "Intro1Body")
    /// Get secure and private
    /// access to the Internet
    public static let intro1Title = L10n.tr("Introduction", "Intro1Title")
    /// Best of all, with one SysVPN account, you can
    /// secure up to 6 devices at the same time
    public static let intro2Body = L10n.tr("Introduction", "Intro2Body")
    /// Support Cross-Platform With Just One Subscription
    public static let intro2Title = L10n.tr("Introduction", "Intro2Title")
    /// Whether it’s high-speed streaming, browsing, security, file sharing, or privacy; you get everything with SysVPN!
    public static let intro3Body = L10n.tr("Introduction", "Intro3Body")
    /// Fast & Stable Speed From Anywhere To Everywhere
    public static let intro3Title = L10n.tr("Introduction", "Intro3Title")
    /// START FREE 30-DAY TRIAL
    public static let trialButton = L10n.tr("Introduction", "trialButton")
  }
  public enum Login {
    /// Start protecting yourself with SysVPN
    public static let body = L10n.tr("Login", "Body")
    /// Create new
    public static let createNew = L10n.tr("Login", "CreateNew")
    /// Your email
    public static let emailPlaceholder = L10n.tr("Login", "EmailPlaceholder")
    /// Forgot password?
    public static let forgotPassword = L10n.tr("Login", "ForgotPassword")
    /// Don't have an account?
    public static let noAccountQuestion = L10n.tr("Login", "NoAccountQuestion")
    /// Your password
    public static let passwordPlaceholder = L10n.tr("Login", "PasswordPlaceholder")
    /// Sign In
    public static let signin = L10n.tr("Login", "Signin")
    /// Sign In With Apple
    public static let signinWithApple = L10n.tr("Login", "SigninWithApple")
    /// Sign In With Google
    public static let signinWithGoogle = L10n.tr("Login", "SigninWithGoogle")
    /// Welcome back
    public static let title = L10n.tr("Login", "Title")
    /// Your username
    public static let usernamePlaceholder = L10n.tr("Login", "UsernamePlaceholder")
  }
  public enum Notice {
    /// By clicking "Agree & Continue", you confirm to agree to our
    public static let agreement = L10n.tr("Notice", "agreement")
    /// and
    public static let and = L10n.tr("Notice", "and")
    /// Agree & Continue
    public static let buttonText = L10n.tr("Notice", "ButtonText")
    /// This is foundation of Sysvpn, and that’s why we want to be crystal clear about what data you agree to share with us. This data is necessary to grant you the best user expericence and provide a top-quality privacy protection service:
    public static let firstGraph = L10n.tr("Notice", "FirstGraph")
    /// Your email address is needed for logging in, forgotten password retrieval, and sending information on important service updates.
    public static let firstTerm = L10n.tr("Notice", "FirstTerm")
    /// That’s all. We strictly don’t monitor, record, or log your online activities nor personal data. What you do online stays only between you and your device.
    public static let lastGraph = L10n.tr("Notice", "LastGraph")
    /// Privacy Policy
    public static let privacyPolicy = L10n.tr("Notice", "PrivacyPolicy")
    /// Anonymous applications usage data (including the version of your device & its operating system) us collected to improve & troubleshoot our app.
    public static let secondTerm = L10n.tr("Notice", "SecondTerm")
    /// Terms of Services
    public static let termOfService = L10n.tr("Notice", "TermOfService")
    /// We respect your privacy
    public static let title = L10n.tr("Notice", "Title")
  }
  public enum PlanSelect {
    /// Account limit reached
    public static let accountLimit = L10n.tr("PlanSelect", "AccountLimit")
    /// You already have a SysVPN account associated with Apple ID. Please log in on that account to continue.
    public static let accountLimitNote = L10n.tr("PlanSelect", "AccountLimitNote")
    /// All plans include protection for 6 devices
    public static let body = L10n.tr("PlanSelect", "body")
    /// Get 24-Month Plan
    public static let continueButton = L10n.tr("PlanSelect", "continueButton")
    /// Got it
    public static let gotIt = L10n.tr("PlanSelect", "GotIt")
    /// mo
    public static let month = L10n.tr("PlanSelect", "month")
    /// Pay after 7 days. Subscription auto-renews every 1 years
    /// until canceled.
    public static let note = L10n.tr("PlanSelect", "note")
    /// Subscription auto-renews every 2 years until canceled.
    public static let notePlan = L10n.tr("PlanSelect", "notePlan")
    /// Select a plan
    public static let title = L10n.tr("PlanSelect", "title")
    public enum PlanA {
      /// đ2,748,000 billed every 2 years. 7-day free trial.
      public static let description = L10n.tr("PlanSelect", "PlanA.description")
      /// Pay after 7 days. Subscription auto-renews every year
      /// until canceled.
      public static let note = L10n.tr("PlanSelect", "PlanA.note")
      /// $6.99
      public static let price = L10n.tr("PlanSelect", "PlanA.price")
      /// Save 12.5
      public static let savingText = L10n.tr("PlanSelect", "PlanA.savingText")
      /// 1-Year plan
      public static let title = L10n.tr("PlanSelect", "PlanA.title")
    }
    public enum PlanB {
      /// $44.99 billed every 6 months.
      public static let description = L10n.tr("PlanSelect", "PlanB.description")
      /// Subscription auto-renews every 6 months until canceled.
      public static let note = L10n.tr("PlanSelect", "PlanB.note")
      /// $7.49
      public static let price = L10n.tr("PlanSelect", "PlanB.price")
      /// Save 6
      public static let savingText = L10n.tr("PlanSelect", "PlanB.savingText")
      /// 6-Months Plan
      public static let title = L10n.tr("PlanSelect", "PlanB.title")
    }
    public enum PlanC {
      /// $7.99 billed every month.
      public static let description = L10n.tr("PlanSelect", "PlanC.description")
      /// 
      public static let note = L10n.tr("PlanSelect", "PlanC.note")
      /// $7.99
      public static let price = L10n.tr("PlanSelect", "PlanC.price")
      /// 
      public static let savingText = L10n.tr("PlanSelect", "PlanC.savingText")
      /// 1-Month Plan
      public static let title = L10n.tr("PlanSelect", "PlanC.title")
    }
  }
  public enum Register {
    /// Start protecting yourself with SysVPN
    public static let body = L10n.tr("Register", "Body")
    /// Your Email
    public static let emailPlaceholder = L10n.tr("Register", "EmailPlaceholder")
    /// Already have an account?
    public static let hadAccountText = L10n.tr("Register", "HadAccountText")
    /// Your Password
    public static let passwordPlaceholder = L10n.tr("Register", "PasswordPlaceholder")
    /// Retype Your Password
    public static let retypePassword = L10n.tr("Register", "RetypePassword")
    /// Sign In
    public static let signin = L10n.tr("Register", "Signin")
    /// Create An Account
    public static let signup = L10n.tr("Register", "Signup")
    /// Sign up with Apple
    public static let signupWithApple = L10n.tr("Register", "SignupWithApple")
    /// Sign up with Google
    public static let signupWithGoogle = L10n.tr("Register", "SignupWithGoogle")
    /// Create an account
    public static let title = L10n.tr("Register", "Title")
  }
  public enum Settings {
    /// About Us
    public static let aboutUs = L10n.tr("Settings", "aboutUs")
    /// Always
    public static let alwaysConnect = L10n.tr("Settings", "alwaysConnect")
    /// Enables access to printers, Tvs, and other devices when connected
    public static let contentItemLocalNetwork = L10n.tr("Settings", "contentItemLocalNetwork")
    /// Metered VPN connection gives you more control over how much data your phone uses through downloads and other apps
    public static let contentItemMetered = L10n.tr("Settings", "contentItemMetered")
    /// Recommend
    public static let contentItemProtocol = L10n.tr("Settings", "contentItemProtocol")
    /// Disables VPN for selected apps
    public static let contentItemSplit = L10n.tr("Settings", "contentItemSplit")
    /// Recommend
    public static let contentRecommend = L10n.tr("Settings", "contentRecommend")
    /// Current version
    public static let currentVersion = L10n.tr("Settings", "currentVersion")
    /// Disabled
    public static let disabled = L10n.tr("Settings", "disabled")
    /// Enabled
    public static let enabled = L10n.tr("Settings", "enabled")
    /// Fastest server
    public static let fastestConnect = L10n.tr("Settings", "fastestConnect")
    /// Auto-connect
    public static let itemAuto = L10n.tr("Settings", "itemAuto")
    /// DNS
    public static let itemDNS = L10n.tr("Settings", "itemDNS")
    /// Help improve SysVpn
    public static let itemHelp = L10n.tr("Settings", "itemHelp")
    /// Local network discovery
    public static let itemLocalNetwork = L10n.tr("Settings", "itemLocalNetwork")
    /// Metered connection
    public static let itemPMetered = L10n.tr("Settings", "itemPMetered")
    /// Protocol
    public static let itemProtocol = L10n.tr("Settings", "itemProtocol")
    /// Split tunneling
    public static let itemSplit = L10n.tr("Settings", "itemSplit")
    /// Tools
    public static let itemTool = L10n.tr("Settings", "itemTool")
    /// VPN connection
    public static let itemVPN = L10n.tr("Settings", "itemVPN")
    /// Licenses
    public static let licenses = L10n.tr("Settings", "licenses")
    /// Off
    public static let offConnect = L10n.tr("Settings", "offConnect")
    /// On mobile networks
    public static let onMobileConnect = L10n.tr("Settings", "onMobileConnect")
    /// On Wi-fi
    public static let onWifiConnect = L10n.tr("Settings", "onWifiConnect")
    /// OpenVPN - TCP
    public static let openVPNTCP = L10n.tr("Settings", "openVPNTCP")
    /// OpenVPN - UDP
    public static let openVPNUDP = L10n.tr("Settings", "openVPNUDP")
    /// Privacy policies
    public static let privacyPolicty = L10n.tr("Settings", "privacyPolicty")
    /// Auto-connect to
    public static let sectionAutoConnect = L10n.tr("Settings", "sectionAutoConnect")
    /// Others
    public static let sectionOther = L10n.tr("Settings", "sectionOther")
    /// VPN Settings
    public static let sectionVPN = L10n.tr("Settings", "sectionVPN")
    /// settings
    public static let settings = L10n.tr("Settings", "settings")
    /// Terms & Conditions
    public static let termAndCondition = L10n.tr("Settings", "termAndCondition")
    /// Settings
    public static let title = L10n.tr("Settings", "title")
    /// WireGuard
    public static let wireGuard = L10n.tr("Settings", "wireGuard")
    public enum Dns {
      /// Custom
      public static let custom = L10n.tr("Settings", "DNS.custom")
      /// Default
      public static let `default` = L10n.tr("Settings", "DNS.default")
      /// Save
      public static let save = L10n.tr("Settings", "DNS.save")
      /// DNS Settings
      public static let title = L10n.tr("Settings", "DNS.title")
      public enum Custom {
        /// Primary DNS
        public static let primaryDNS = L10n.tr("Settings", "DNS.custom.primaryDNS")
        /// Secondary DNS
        public static let secondaryDNS = L10n.tr("Settings", "DNS.custom.secondaryDNS")
        /// Custom DNS server
        public static let title = L10n.tr("Settings", "DNS.custom.title")
      }
      public enum Default {
        /// Use default gateway on remote network
        public static let content = L10n.tr("Settings", "DNS.default.content")
      }
    }
    public enum Tools {
      /// CyberSec
      public static let cyberSec = L10n.tr("Settings", "Tools.cyberSec")
      /// Dark Web Monitors
      public static let darkWebMonitors = L10n.tr("Settings", "Tools.darkWebMonitors")
      /// Kill Switch
      public static let killSwitch = L10n.tr("Settings", "Tools.killSwitch")
      /// Tapjacking protection
      public static let tapJackingProtection = L10n.tr("Settings", "Tools.tapJackingProtection")
      /// Tools
      public static let title = L10n.tr("Settings", "Tools.title")
      public enum CyberSec {
        /// Protects you from cyber threats by blocking malicious website.
        public static let note = L10n.tr("Settings", "Tools.cyberSec.note")
      }
      public enum DarkWebMonitors {
        /// Sends alerts if your credentials get publicly exposed online.
        public static let note = L10n.tr("Settings", "Tools.darkWebMonitors.note")
      }
      public enum KillSwitch {
        /// Blocks unprotected traffic if VPN connection drops.
        public static let note = L10n.tr("Settings", "Tools.killSwitch.note")
      }
      public enum TapJackingProtection {
        /// Warns you if a malicous app adds a screen overlay to trick you into unintended action.
        public static let note = L10n.tr("Settings", "Tools.tapJackingProtection.note")
      }
    }
  }
  public enum StaticIP {
    /// CURRENT LOAD
    public static let currentLoad = L10n.tr("StaticIP", "CurrentLoad")
    /// Static ip
    public static let staticIP = L10n.tr("StaticIP", "StaticIP")
  }
  public enum SubscriptionIntro {
    /// Blazing-fast & stable globally servers network
    public static let cashback = L10n.tr("SubscriptionIntro", "cashback")
    /// Continue without subscription
    public static let continueWithoutSub = L10n.tr("SubscriptionIntro", "continueWithoutSub")
    /// 24/7 live customer support
    public static let liveSupport = L10n.tr("SubscriptionIntro", "liveSupport")
    /// Auto-renewable subscription info:
    /// 
    /// The payment will be charged to your Play Store Account at confirmation of purchase
    /// 
    /// The subscription renews automatically unless the auto-renew is turned off at least 24 hours before the end of the current billing period
    /// 
    /// Yout account will be charged for renewal within 24 hours prior to the end of your selected subscription
    /// 
    /// You can manager subscription and turn off auto-renewal after purchase by going to your Account Settings
    public static let note = L10n.tr("SubscriptionIntro", "note")
    /// Blazing-fast & stable globally servers network
    public static let rocketFast = L10n.tr("SubscriptionIntro", "rocketFast")
    /// Start your 30-day free trial
    public static let startFreeTrial = L10n.tr("SubscriptionIntro", "startFreeTrial")
    /// Subscription
    public static let title = L10n.tr("SubscriptionIntro", "Title")
    /// One account for All your devices
    public static let unlimited = L10n.tr("SubscriptionIntro", "unlimited")
  }
  public enum Welcome {
    /// Now you can connect to VPN and enjoy
    /// ultimate privacy and security online.
    public static let message = L10n.tr("Welcome", "message")
    /// Setup Now
    public static let setupButton = L10n.tr("Welcome", "setupButton")
    /// Setup Your VPN
    public static let setupVPN = L10n.tr("Welcome", "setupVPN")
    /// Your device will ask permission to complete the configuration.
    public static let setupVPNMessage = L10n.tr("Welcome", "setupVPNMessage")
    /// Start Protecting Yourself
    public static let startButton = L10n.tr("Welcome", "startButton")
    /// Welcome to SysVPN
    public static let title = L10n.tr("Welcome", "title")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
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
