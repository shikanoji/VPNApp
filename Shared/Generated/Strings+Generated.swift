// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  public enum Account {
    /// My Account
    public static let account = L10n.tr("Account", "Account", fallback: "My Account")
    /// Multiple devices online
    public static let contentTotalDevices = L10n.tr("Account", "contentTotalDevices", fallback: "Multiple devices online")
    /// Delete your account
    public static let deleteAccount = L10n.tr("Account", "deleteAccount", fallback: "Delete your account")
    /// Expire on
    public static let expire = L10n.tr("Account", "expire", fallback: "Expire on")
    /// Free plan
    public static let freePlan = L10n.tr("Account", "freePlan", fallback: "Free plan")
    /// Account status:
    public static let itemAccount = L10n.tr("Account", "itemAccount", fallback: "Account status:")
    /// Devices
    public static let itemDevices = L10n.tr("Account", "itemDevices", fallback: "Devices")
    /// Help Center
    public static let itemHelpCenter = L10n.tr("Account", "itemHelpCenter", fallback: "Help Center")
    /// Frequently Asked Questions
    public static let itemQuestions = L10n.tr("Account", "itemQuestions", fallback: "Frequently Asked Questions")
    /// Sercurity level
    public static let itemSecurity = L10n.tr("Account", "itemSecurity", fallback: "Sercurity level")
    /// Premium
    public static let premium = L10n.tr("Account", "premium", fallback: "Premium")
    /// Premium plan only $3/month
    public static let premiumOffer = L10n.tr("Account", "premiumOffer", fallback: "Premium plan only $3/month")
    /// Sign Out
    public static let signout = L10n.tr("Account", "signout", fallback: "Sign Out")
    /// Help & Support
    public static let support = L10n.tr("Account", "Support", fallback: "Help & Support")
    /// Account
    public static let titleAccount = L10n.tr("Account", "titleAccount", fallback: "Account")
    /// Settings.strings
    ///   SysVPN
    /// 
    ///   Created by Da Phan Van on 14/01/2022.
    public static let viewProfile = L10n.tr("Account", "viewProfile", fallback: "View Profile")
    public enum AccountStatus {
      /// Change Plan
      public static let extend = L10n.tr("Account", "AccountStatus.extend", fallback: "Change Plan")
      /// Joined
      public static let joined = L10n.tr("Account", "AccountStatus.joined", fallback: "Joined")
      /// Payment history
      public static let paymentHistory = L10n.tr("Account", "AccountStatus.paymentHistory", fallback: "Payment history")
      /// Tap to show
      public static let tapToShow = L10n.tr("Account", "AccountStatus.tapToShow", fallback: "Tap to show")
      /// Your Subscription
      public static let title = L10n.tr("Account", "AccountStatus.title", fallback: "Your Subscription")
      /// Premium plan only $3/month
      public static let upgradeToPremium = L10n.tr("Account", "AccountStatus.upgradeToPremium", fallback: "Premium plan only $3/month")
      public enum PaymentHistory {
        /// Failed
        public static let failed = L10n.tr("Account", "AccountStatus.paymentHistory.Failed", fallback: "Failed")
        /// Success
        public static let success = L10n.tr("Account", "AccountStatus.paymentHistory.Success", fallback: "Success")
      }
    }
    public enum ChangePassword {
      /// Confirm password does not matche
      public static let passwordNotMatch = L10n.tr("Account", "ChangePassword.passwordNotMatch", fallback: "Confirm password does not matche")
      /// Successfully changed password
      public static let success = L10n.tr("Account", "ChangePassword.success", fallback: "Successfully changed password")
    }
    public enum DeleteAccount {
      /// Delete
      public static let delete = L10n.tr("Account", "DeleteAccount.delete", fallback: "Delete")
      /// Please note that the deletion of an account doesn't have an impact on your subscription payments. For that, you also need to cancel your subscription or request a refund as well.
      public static let message = L10n.tr("Account", "DeleteAccount.message", fallback: "Please note that the deletion of an account doesn't have an impact on your subscription payments. For that, you also need to cancel your subscription or request a refund as well.")
      /// Note: This action cannot be undone.
      public static let note = L10n.tr("Account", "DeleteAccount.note", fallback: "Note: This action cannot be undone.")
    }
    public enum Infomation {
      /// Change password
      public static let changePassword = L10n.tr("Account", "Infomation.changePassword", fallback: "Change password")
      /// Current Password
      public static let currentPassword = L10n.tr("Account", "Infomation.currentPassword", fallback: "Current Password")
      /// Your email
      public static let email = L10n.tr("Account", "Infomation.email", fallback: "Your email")
      /// SysVpn id
      public static let id = L10n.tr("Account", "Infomation.id", fallback: "SysVpn id")
      /// Enter current & new password
      public static let introChangePassword = L10n.tr("Account", "Infomation.introChangePassword", fallback: "Enter current & new password")
      /// Member since
      public static let member = L10n.tr("Account", "Infomation.member", fallback: "Member since")
      /// New Password
      public static let newPassword = L10n.tr("Account", "Infomation.newPassword", fallback: "New Password")
      /// Retype New Password
      public static let retypePassword = L10n.tr("Account", "Infomation.retypePassword", fallback: "Retype New Password")
      /// Save
      public static let save = L10n.tr("Account", "Infomation.save", fallback: "Save")
      /// Account sercurity
      public static let security = L10n.tr("Account", "Infomation.security", fallback: "Account sercurity")
      /// Set password
      public static let setPassword = L10n.tr("Account", "Infomation.setPassword", fallback: "Set password")
      /// Set password for your account.
      public static let setPasswordNote = L10n.tr("Account", "Infomation.setPasswordNote", fallback: "Set password for your account.")
      /// Tap to change password
      public static let tapToChangePassword = L10n.tr("Account", "Infomation.tapToChangePassword", fallback: "Tap to change password")
      /// Infomation
      public static let title = L10n.tr("Account", "Infomation.title", fallback: "Infomation")
    }
    public enum Logout {
      /// Confirm Sign Out
      public static let confirm = L10n.tr("Account", "Logout.Confirm", fallback: "Confirm Sign Out")
      /// Sign Out
      public static let signOut = L10n.tr("Account", "Logout.SignOut", fallback: "Sign Out")
      public enum Confirm {
        /// All VPN connections will be disconnected when you sign out. Are you sure you want to continue?
        public static let message = L10n.tr("Account", "Logout.Confirm.Message", fallback: "All VPN connections will be disconnected when you sign out. Are you sure you want to continue?")
      }
    }
    public enum PaymentHistory {
      /// Cancel Subscription
      public static let cancelSubscription = L10n.tr("Account", "PaymentHistory.cancelSubscription", fallback: "Cancel Subscription")
    }
    public enum Session {
      public enum Expired {
        /// Login Again
        public static let button = L10n.tr("Account", "Session.Expired.Button", fallback: "Login Again")
        /// Your session has expired. Please login again to continue.
        public static let message = L10n.tr("Account", "Session.Expired.Message", fallback: "Your session has expired. Please login again to continue.")
        /// Session expired.
        public static let title = L10n.tr("Account", "Session.Expired.Title", fallback: "Session expired.")
      }
      public enum Terminal {
        /// Are you sure to terminate this session
        public static let message = L10n.tr("Account", "Session.Terminal.Message", fallback: "Are you sure to terminate this session")
        /// Terminate
        public static let terminate = L10n.tr("Account", "Session.Terminal.Terminate", fallback: "Terminate")
        /// Terminate session
        public static let title = L10n.tr("Account", "Session.Terminal.Title", fallback: "Terminate session")
      }
    }
  }
  public enum Board {
    /// Back to maps
    public static let backToMap = L10n.tr("Board", "backToMap", fallback: "Back to maps")
    /// Protected
    public static let connected = L10n.tr("Board", "Connected", fallback: "Protected")
    /// Connected
    public static let connectedAlert = L10n.tr("Board", "ConnectedAlert", fallback: "Connected")
    /// Connecting...
    public static let connecting = L10n.tr("Board", "Connecting", fallback: "Connecting...")
    /// strings
    ///   SysVPN
    /// 
    ///   Created by Da Phan Van on 23/12/2021.
    public static let ip = L10n.tr("Board", "IP", fallback: "Your IP: ")
    /// Locations
    public static let locationTitleTab = L10n.tr("Board", "LocationTitleTab", fallback: "Locations")
    /// MultiHop
    public static let multiHopTitleTab = L10n.tr("Board", "MultiHopTitleTab", fallback: "MultiHop")
    /// VPN connected
    public static let navigationTitleConnected = L10n.tr("Board", "NavigationTitleConnected", fallback: "VPN connected")
    /// Connecting...
    public static let navigationTitleConnecting = L10n.tr("Board", "NavigationTitleConnecting", fallback: "Connecting...")
    /// VPN not connected
    public static let navigationTitleNotConnect = L10n.tr("Board", "NavigationTitleNotConnect", fallback: "VPN not connected")
    /// Quick 
    ///  Connect
    public static let quickUnConnect = L10n.tr("Board", "QuickUnConnect", fallback: "Quick \n Connect")
    /// /s
    public static let speed = L10n.tr("Board", "Speed", fallback: "/s")
    /// Static IP
    public static let staticIPTitleTab = L10n.tr("Board", "StaticIPTitleTab", fallback: "Static IP")
    /// Connect to VPN for online security
    public static let subIP = L10n.tr("Board", "SubIP", fallback: "Connect to VPN for online security")
    /// Unprotected
    public static let unconnect = L10n.tr("Board", "Unconnect", fallback: "Unprotected")
    public enum BoardList {
      /// All countries
      public static let allCountries = L10n.tr("Board", "BoardList.AllCountries", fallback: "All countries")
      /// available
      public static let available = L10n.tr("Board", "BoardList.Available", fallback: "available")
      /// cities
      public static let cities = L10n.tr("Board", "BoardList.Cities", fallback: "cities")
      /// city
      public static let city = L10n.tr("Board", "BoardList.City", fallback: "city")
      /// City of
      public static let cityOf = L10n.tr("Board", "BoardList.CityOf", fallback: "City of")
      /// Recent locations
      public static let recentLocations = L10n.tr("Board", "BoardList.RecentLocations", fallback: "Recent locations")
      /// Recommended
      public static let recommended = L10n.tr("Board", "BoardList.Recommended", fallback: "Recommended")
      /// Search
      public static let search = L10n.tr("Board", "BoardList.Search", fallback: "Search")
      /// Single location
      public static let singleLocation = L10n.tr("Board", "BoardList.SingleLocation", fallback: "Single location")
      public enum MultiHop {
        /// Connect
        public static let connect = L10n.tr("Board", "BoardList.MultiHop.Connect", fallback: "Connect")
        /// A multiHop VPN, also known as a double VPN, works by sending your internet traffic through two secure servers rather than one when you go online. Consider this as a secure tunnel inside a secure tunnel, which provides an extra layer of security. As your data reaches each server, it receives another extra layer of traffic encryption (double-encrypted), to the point where your data is almost entirely inaccessible to cybercriminals, ensuring both your IP and traffic are therefore protected twice as much.
        public static let contentMultiHop = L10n.tr("Board", "BoardList.MultiHop.ContentMultiHop", fallback: "A multiHop VPN, also known as a double VPN, works by sending your internet traffic through two secure servers rather than one when you go online. Consider this as a secure tunnel inside a secure tunnel, which provides an extra layer of security. As your data reaches each server, it receives another extra layer of traffic encryption (double-encrypted), to the point where your data is almost entirely inaccessible to cybercriminals, ensuring both your IP and traffic are therefore protected twice as much.")
        /// Exit location represents your main VPN server
        public static let exit = L10n.tr("Board", "BoardList.MultiHop.Exit", fallback: "Exit location represents your main VPN server")
        /// Got it
        public static let gotIt = L10n.tr("Board", "BoardList.MultiHop.GotIt", fallback: "Got it")
        /// Recent connections
        public static let recentConnections = L10n.tr("Board", "BoardList.MultiHop.RecentConnections", fallback: "Recent connections")
        /// Select entry location
        public static let selectEntryLocation = L10n.tr("Board", "BoardList.MultiHop.SelectEntryLocation", fallback: "Select entry location")
        /// Select exit location
        public static let selectExitLocation = L10n.tr("Board", "BoardList.MultiHop.SelectExitLocation", fallback: "Select exit location")
        /// What is multihop?
        public static let what = L10n.tr("Board", "BoardList.MultiHop.What", fallback: "What is multihop?")
      }
    }
  }
  public enum Faq {
    /// About SysVPN
    public static let aboutSysvpn = L10n.tr("FAQ", "aboutSysvpn", fallback: "About SysVPN")
    /// SysVPN Subscriptions
    public static let sysvpnSubscription = L10n.tr("FAQ", "sysvpnSubscription", fallback: "SysVPN Subscriptions")
    /// strings
    ///   SysVPN
    /// 
    ///   Created by Nguyễn Đình Thạch on 09/02/2022.
    public static let title = L10n.tr("FAQ", "title", fallback: "Frequently Asked Questions")
    /// VPN Basic
    public static let vpnbasic = L10n.tr("FAQ", "vpnbasic", fallback: "VPN Basic")
  }
  public enum ForgotPassword {
    /// It's great to see you back
    public static let body = L10n.tr("ForgotPassword", "Body", fallback: "It's great to see you back")
    /// Your email
    public static let emailPlaceholder = L10n.tr("ForgotPassword", "EmailPlaceholder", fallback: "Your email")
    /// Send request
    public static let sendRequestButton = L10n.tr("ForgotPassword", "SendRequestButton", fallback: "Send request")
    /// Please check your e-mail to reset password.
    public static let success = L10n.tr("ForgotPassword", "Success", fallback: "Please check your e-mail to reset password.")
    /// strings
    ///   SysVPN
    /// 
    ///   Created by Nguyễn Đình Thạch on 28/12/2021.
    public static let title = L10n.tr("ForgotPassword", "Title", fallback: "Forgot Password")
  }
  public enum Global {
    /// An error occurred
    public static let anErrorOccurred = L10n.tr("Global", "An error occurred", fallback: "An error occurred")
    /// Back
    public static let back = L10n.tr("Global", "Back", fallback: "Back")
    /// Cancel
    public static let cancel = L10n.tr("Global", "cancel", fallback: "Cancel")
    /// Default
    public static let `default` = L10n.tr("Global", "default", fallback: "Default")
    /// Error
    public static let error = L10n.tr("Global", "Error", fallback: "Error")
    /// Network is unstable! Please check your internet connection
    public static let noInternet = L10n.tr("Global", "noInternet", fallback: "Network is unstable! Please check your internet connection")
    /// Off
    public static let off = L10n.tr("Global", "off", fallback: "Off")
    /// OK
    public static let ok = L10n.tr("Global", "ok", fallback: "OK")
    /// On
    public static let on = L10n.tr("Global", "on", fallback: "On")
    /// An email was sent to your email.
    public static let requestDeleteMessage = L10n.tr("Global", "requestDeleteMessage", fallback: "An email was sent to your email.")
    /// Saved successfully!
    public static let saveSuccess = L10n.tr("Global", "SaveSuccess", fallback: "Saved successfully!")
    /// Localizations.strings
    ///   SysVPN
    /// 
    ///   Created by Nguyễn Đình Thạch on 06/12/2021.
    public static let slogan = L10n.tr("Global", "slogan", fallback: "Right Protection, Right Time")
    /// Something went wrong
    public static let somethingWrong = L10n.tr("Global", "SomethingWrong", fallback: "Something went wrong")
    /// Unverified
    public static let unverified = L10n.tr("Global", "Unverified", fallback: "Unverified")
    /// Verified
    public static let verified = L10n.tr("Global", "Verified", fallback: "Verified")
    /// You're offline
    public static let youReOffline = L10n.tr("Global", "You're offline", fallback: "You're offline")
  }
  public enum Introduction {
    /// SysVPN brings top-notch security by encrypting your connection, masking your sensitive info, and disguising your online activities from snoopers
    public static let intro1Body = L10n.tr("Introduction", "Intro1Body", fallback: "SysVPN brings top-notch security by encrypting your connection, masking your sensitive info, and disguising your online activities from snoopers")
    /// Shield your virtual life
    public static let intro1Title = L10n.tr("Introduction", "Intro1Title", fallback: "Shield your virtual life")
    /// Best of all, with one SysVPN account, you can
    /// secure up to 6 devices at the same time
    public static let intro2Body = L10n.tr("Introduction", "Intro2Body", fallback: "Best of all, with one SysVPN account, you can\nsecure up to 6 devices at the same time")
    /// Support cross-platform with just one subscription
    public static let intro2Title = L10n.tr("Introduction", "Intro2Title", fallback: "Support cross-platform with just one subscription")
    /// Whether it’s high-speed streaming, browsing, file sharing, or privacy; you get everything with SysVPN!
    public static let intro3Body = L10n.tr("Introduction", "Intro3Body", fallback: "Whether it’s high-speed streaming, browsing, file sharing, or privacy; you get everything with SysVPN!")
    /// Fast & stable speed from anywhere to everywhere
    public static let intro3Title = L10n.tr("Introduction", "Intro3Title", fallback: "Fast & stable speed from anywhere to everywhere")
    /// You won’t be charged until the trial period ends
    public static let introBottomTitle = L10n.tr("Introduction", "IntroBottomTitle", fallback: "You won’t be charged until the trial period ends")
    /// strings
    ///   SysVPN
    /// 
    ///   Created by Nguyễn Đình Thạch on 22/12/2021.
    public static let trialButton = L10n.tr("Introduction", "trialButton", fallback: "Create a new account")
    /// Update New Version
    public static let updateNewVersion = L10n.tr("Introduction", "UpdateNewVersion", fallback: "Update New Version")
    /// Update Required
    public static let updateRequired = L10n.tr("Introduction", "UpdateRequired", fallback: "Update Required")
    /// The current version of SYSVPN is no longer supported. Please update the app to continue using the app.
    public static let updateRequiredNote = L10n.tr("Introduction", "UpdateRequiredNote", fallback: "The current version of SYSVPN is no longer supported. Please update the app to continue using the app.")
  }
  public enum Login {
    /// Start protecting yourself with SysVPN
    public static let body = L10n.tr("Login", "Body", fallback: "Start protecting yourself with SysVPN")
    /// Sign up
    public static let createNew = L10n.tr("Login", "CreateNew", fallback: "Sign up")
    /// Your email
    public static let emailPlaceholder = L10n.tr("Login", "EmailPlaceholder", fallback: "Your email")
    /// Forgot your password?
    public static let forgotPassword = L10n.tr("Login", "ForgotPassword", fallback: "Forgot your password?")
    /// Don't have an account?
    public static let noAccountQuestion = L10n.tr("Login", "NoAccountQuestion", fallback: "Don't have an account?")
    /// Password
    public static let passwordPlaceholder = L10n.tr("Login", "PasswordPlaceholder", fallback: "Password")
    /// Sign in
    public static let signin = L10n.tr("Login", "Signin", fallback: "Sign in")
    /// Or sign in with
    public static let signInWith = L10n.tr("Login", "signInWith", fallback: "Or sign in with")
    /// Apple
    public static let signinWithApple = L10n.tr("Login", "SigninWithApple", fallback: "Apple")
    /// Google
    public static let signinWithGoogle = L10n.tr("Login", "SigninWithGoogle", fallback: "Google")
    /// strings
    ///   SysVPN
    /// 
    ///   Created by Nguyễn Đình Thạch on 22/12/2021.
    public static let title = L10n.tr("Login", "Title", fallback: "Welcome back")
    /// Your username
    public static let usernamePlaceholder = L10n.tr("Login", "UsernamePlaceholder", fallback: "Your username")
  }
  public enum Notice {
    /// By clicking "Agree & Continue", you confirm to agree to our
    public static let agreement = L10n.tr("Notice", "agreement", fallback: "By clicking \"Agree & Continue\", you confirm to agree to our")
    /// and
    public static let and = L10n.tr("Notice", "and", fallback: "and")
    /// Agree & Continue
    public static let buttonText = L10n.tr("Notice", "ButtonText", fallback: "Agree & Continue")
    /// This is foundation of Sysvpn, and that’s why we want to be crystal clear about what data you agree to share with us. This data is necessary to grant you the best user expericence and provide a top-quality privacy protection service:
    public static let firstGraph = L10n.tr("Notice", "FirstGraph", fallback: "This is foundation of Sysvpn, and that’s why we want to be crystal clear about what data you agree to share with us. This data is necessary to grant you the best user expericence and provide a top-quality privacy protection service:")
    /// Your email address is needed for logging in, forgotten password retrieval, and sending information on important service updates.
    public static let firstTerm = L10n.tr("Notice", "FirstTerm", fallback: "Your email address is needed for logging in, forgotten password retrieval, and sending information on important service updates.")
    /// That’s all. We strictly don’t monitor, record, or log your online activities nor personal data. What you do online stays only between you and your device.
    public static let lastGraph = L10n.tr("Notice", "LastGraph", fallback: "That’s all. We strictly don’t monitor, record, or log your online activities nor personal data. What you do online stays only between you and your device.")
    /// Privacy Policy
    public static let privacyPolicy = L10n.tr("Notice", "PrivacyPolicy", fallback: "Privacy Policy")
    /// Anonymous applications usage data (including the version of your device & its operating system) us collected to improve & troubleshoot our app.
    public static let secondTerm = L10n.tr("Notice", "SecondTerm", fallback: "Anonymous applications usage data (including the version of your device & its operating system) us collected to improve & troubleshoot our app.")
    /// Terms of Services
    public static let termOfService = L10n.tr("Notice", "TermOfService", fallback: "Terms of Services")
    /// strings
    ///   SysVPN
    /// 
    ///   Created by Nguyễn Đình Thạch on 05/01/2022.
    public static let title = L10n.tr("Notice", "Title", fallback: "We respect your privacy")
  }
  public enum PlanSelect {
    /// Account limit reached
    public static let accountLimit = L10n.tr("PlanSelect", "AccountLimit", fallback: "Account limit reached")
    /// You already have a SysVPN account associated with Apple ID. Please log in on that account to continue.
    public static let accountLimitNote = L10n.tr("PlanSelect", "AccountLimitNote", fallback: "You already have a SysVPN account associated with Apple ID. Please log in on that account to continue.")
    /// All plans include protection for 6 devices
    public static let body = L10n.tr("PlanSelect", "body", fallback: "All plans include protection for 6 devices")
    /// Start exploring and enjoy all  
    ///  cybersercurity features for free
    public static let content1 = L10n.tr("PlanSelect", "content1", fallback: "Start exploring and enjoy all  \n cybersercurity features for free")
    /// Receive a reminder email about the 
    ///  upcoming free trial expiration
    public static let content2 = L10n.tr("PlanSelect", "content2", fallback: "Receive a reminder email about the \n upcoming free trial expiration")
    /// Pay for your 6-month plan for $100 if you 
    ///  haven’t canceled your subscription before the trial ends.
    public static let content3 = L10n.tr("PlanSelect", "content3", fallback: "Pay for your 6-month plan for $100 if you \n haven’t canceled your subscription before the trial ends.")
    /// Continue
    public static let continueButton = L10n.tr("PlanSelect", "continueButton", fallback: "Continue")
    /// 7-day Free Trial
    public static let dayFreeTrial = L10n.tr("PlanSelect", "dayFreeTrial", fallback: "7-day Free Trial")
    /// See how free trial works.
    public static let dayFreeTrialSub = L10n.tr("PlanSelect", "dayFreeTrialSub", fallback: "See how free trial works.")
    /// Got it
    public static let gotIt = L10n.tr("PlanSelect", "GotIt", fallback: "Got it")
    /// Today: Full access to SYSVPN
    public static let header1 = L10n.tr("PlanSelect", "header1", fallback: "Today: Full access to SYSVPN")
    /// Day 5: Reminder email
    public static let header2 = L10n.tr("PlanSelect", "header2", fallback: "Day 5: Reminder email")
    /// Day 7: Free trial ends
    public static let header3 = L10n.tr("PlanSelect", "header3", fallback: "Day 7: Free trial ends")
    /// How 7-day free trial 
    ///  works
    public static let headerSubcription = L10n.tr("PlanSelect", "headerSubcription", fallback: "How 7-day free trial \n works")
    /// month
    public static let month = L10n.tr("PlanSelect", "month", fallback: "month")
    /// See all plans
    public static let seeAllPlan = L10n.tr("PlanSelect", "seeAllPlan", fallback: "See all plans")
    /// START FREE 7-DAY TRIAL
    public static let startFreeTrial = L10n.tr("PlanSelect", "startFreeTrial", fallback: "START FREE 7-DAY TRIAL")
    /// strings
    ///   SysVPN
    /// 
    ///   Created by Nguyễn Đình Thạch on 13/01/2022.
    public static let title = L10n.tr("PlanSelect", "title", fallback: "Select a plan")
    public enum PlanA {
      /// $44.99 billed every 12 months.
      public static let description = L10n.tr("PlanSelect", "PlanA.description", fallback: "$44.99 billed every 12 months.")
      /// Get 12-month plan
      public static let `get` = L10n.tr("PlanSelect", "PlanA.get", fallback: "Get 12-month plan")
      /// Subscription auto-renews every 12 months 
      ///  until canceled.
      public static let note = L10n.tr("PlanSelect", "PlanA.note", fallback: "Subscription auto-renews every 12 months \n until canceled.")
      /// Pay for your 12-month plan for $44.99 if you haven’t canceled your subscription before the trial ends.
      public static let noteTrial = L10n.tr("PlanSelect", "PlanA.noteTrial", fallback: "Pay for your 12-month plan for $44.99 if you haven’t canceled your subscription before the trial ends.")
      /// $3.75
      public static let price = L10n.tr("PlanSelect", "PlanA.price", fallback: "$3.75")
      /// Save 69
      public static let savingText = L10n.tr("PlanSelect", "PlanA.savingText", fallback: "Save 69")
      /// 12-month plan
      public static let title = L10n.tr("PlanSelect", "PlanA.title", fallback: "12-month plan")
    }
    public enum PlanB {
      /// $31.99 billed every 6 months.
      public static let description = L10n.tr("PlanSelect", "PlanB.description", fallback: "$31.99 billed every 6 months.")
      /// Get 6-month plan
      public static let `get` = L10n.tr("PlanSelect", "PlanB.get", fallback: "Get 6-month plan")
      /// Subscription auto-renews every 6 months 
      ///  until canceled.
      public static let note = L10n.tr("PlanSelect", "PlanB.note", fallback: "Subscription auto-renews every 6 months \n until canceled.")
      /// Pay for your 6-month plan for $31.99 if you haven’t canceled your subscription before the trial ends.
      public static let noteTrial = L10n.tr("PlanSelect", "PlanB.noteTrial", fallback: "Pay for your 6-month plan for $31.99 if you haven’t canceled your subscription before the trial ends.")
      /// $5.33
      public static let price = L10n.tr("PlanSelect", "PlanB.price", fallback: "$5.33")
      /// Save 56
      public static let savingText = L10n.tr("PlanSelect", "PlanB.savingText", fallback: "Save 56")
      /// 6-month plan
      public static let title = L10n.tr("PlanSelect", "PlanB.title", fallback: "6-month plan")
    }
    public enum PlanC {
      /// $11.99 billed every month.
      public static let description = L10n.tr("PlanSelect", "PlanC.description", fallback: "$11.99 billed every month.")
      /// Get Monthly plan
      public static let `get` = L10n.tr("PlanSelect", "PlanC.get", fallback: "Get Monthly plan")
      /// Subscription auto-renews every month 
      ///  until canceled.
      public static let note = L10n.tr("PlanSelect", "PlanC.note", fallback: "Subscription auto-renews every month \n until canceled.")
      /// Pay for your Monthly plan for $11.99 if you haven’t canceled your subscription before the trial ends.
      public static let noteTrial = L10n.tr("PlanSelect", "PlanC.noteTrial", fallback: "Pay for your Monthly plan for $11.99 if you haven’t canceled your subscription before the trial ends.")
      /// $11.99
      public static let price = L10n.tr("PlanSelect", "PlanC.price", fallback: "$11.99")
      /// 
      public static let savingText = L10n.tr("PlanSelect", "PlanC.savingText", fallback: "")
      /// Monthly plan
      public static let title = L10n.tr("PlanSelect", "PlanC.title", fallback: "Monthly plan")
    }
  }
  public enum Register {
    /// Start protecting yourself with SysVPN
    public static let body = L10n.tr("Register", "Body", fallback: "Start protecting yourself with SysVPN")
    /// Your email
    public static let emailPlaceholder = L10n.tr("Register", "EmailPlaceholder", fallback: "Your email")
    /// Already have an account?
    public static let hadAccountText = L10n.tr("Register", "HadAccountText", fallback: "Already have an account?")
    /// Password
    public static let passwordPlaceholder = L10n.tr("Register", "PasswordPlaceholder", fallback: "Password")
    /// Retype Your Password
    public static let retypePassword = L10n.tr("Register", "RetypePassword", fallback: "Retype Your Password")
    /// Sign in
    public static let signin = L10n.tr("Register", "Signin", fallback: "Sign in")
    /// Create an account
    public static let signup = L10n.tr("Register", "Signup", fallback: "Create an account")
    /// Or sign up with
    public static let signUpWith = L10n.tr("Register", "signUpWith", fallback: "Or sign up with")
    /// Apple
    public static let signupWithApple = L10n.tr("Register", "SignupWithApple", fallback: "Apple")
    /// Google
    public static let signupWithGoogle = L10n.tr("Register", "SignupWithGoogle", fallback: "Google")
    /// strings
    ///   SysVPN
    /// 
    ///   Created by Nguyễn Đình Thạch on 24/12/2021.
    public static let title = L10n.tr("Register", "Title", fallback: "Create an account")
  }
  public enum Settings {
    /// About Us
    public static let aboutUs = L10n.tr("Settings", "aboutUs", fallback: "About Us")
    /// Always
    public static let alwaysConnect = L10n.tr("Settings", "alwaysConnect", fallback: "Always")
    /// Enables access to printers, Tvs, and other devices when connected
    public static let contentItemLocalNetwork = L10n.tr("Settings", "contentItemLocalNetwork", fallback: "Enables access to printers, Tvs, and other devices when connected")
    /// Metered VPN connection gives you more control over how much data your phone uses through downloads and other apps
    public static let contentItemMetered = L10n.tr("Settings", "contentItemMetered", fallback: "Metered VPN connection gives you more control over how much data your phone uses through downloads and other apps")
    /// Recommended
    public static let contentItemProtocol = L10n.tr("Settings", "contentItemProtocol", fallback: "Recommended")
    /// Disables VPN for selected apps
    public static let contentItemSplit = L10n.tr("Settings", "contentItemSplit", fallback: "Disables VPN for selected apps")
    /// Recommended
    public static let contentRecommended = L10n.tr("Settings", "contentRecommended", fallback: "Recommended")
    /// Current version
    public static let currentVersion = L10n.tr("Settings", "currentVersion", fallback: "Current version")
    /// Disabled
    public static let disabled = L10n.tr("Settings", "disabled", fallback: "Disabled")
    /// Enabled
    public static let enabled = L10n.tr("Settings", "enabled", fallback: "Enabled")
    /// Fastest server
    public static let fastestConnect = L10n.tr("Settings", "fastestConnect", fallback: "Fastest server")
    /// Auto-connect
    public static let itemAuto = L10n.tr("Settings", "itemAuto", fallback: "Auto-connect")
    /// DNS
    public static let itemDNS = L10n.tr("Settings", "itemDNS", fallback: "DNS")
    /// Help improve SysVpn
    public static let itemHelp = L10n.tr("Settings", "itemHelp", fallback: "Help improve SysVpn")
    /// Local network discovery
    public static let itemLocalNetwork = L10n.tr("Settings", "itemLocalNetwork", fallback: "Local network discovery")
    /// Metered connection
    public static let itemPMetered = L10n.tr("Settings", "itemPMetered", fallback: "Metered connection")
    /// Protocol
    public static let itemProtocol = L10n.tr("Settings", "itemProtocol", fallback: "Protocol")
    /// Split tunneling
    public static let itemSplit = L10n.tr("Settings", "itemSplit", fallback: "Split tunneling")
    /// Tools
    public static let itemTool = L10n.tr("Settings", "itemTool", fallback: "Tools")
    /// VPN connection
    public static let itemVPN = L10n.tr("Settings", "itemVPN", fallback: "VPN connection")
    /// Licenses
    public static let licenses = L10n.tr("Settings", "licenses", fallback: "Licenses")
    /// Off
    public static let offConnect = L10n.tr("Settings", "offConnect", fallback: "Off")
    /// On mobile networks
    public static let onMobileConnect = L10n.tr("Settings", "onMobileConnect", fallback: "On mobile networks")
    /// On Wi-fi
    public static let onWifiConnect = L10n.tr("Settings", "onWifiConnect", fallback: "On Wi-fi")
    /// OpenVPN - TCP
    public static let openVPNTCP = L10n.tr("Settings", "openVPNTCP", fallback: "OpenVPN - TCP")
    /// OpenVPN - UDP
    public static let openVPNUDP = L10n.tr("Settings", "openVPNUDP", fallback: "OpenVPN - UDP")
    /// Privacy policies
    public static let privacyPolicty = L10n.tr("Settings", "privacyPolicty", fallback: "Privacy policies")
    /// Auto-connect to
    public static let sectionAutoConnect = L10n.tr("Settings", "sectionAutoConnect", fallback: "Auto-connect to")
    /// Others
    public static let sectionOther = L10n.tr("Settings", "sectionOther", fallback: "Others")
    /// VPN Settings
    public static let sectionVPN = L10n.tr("Settings", "sectionVPN", fallback: "VPN Settings")
    /// settings
    public static let settings = L10n.tr("Settings", "settings", fallback: "settings")
    /// Terms & Conditions
    public static let termAndCondition = L10n.tr("Settings", "termAndCondition", fallback: "Terms & Conditions")
    /// strings
    ///   SysVPN
    /// 
    ///   Created by Da Phan Van on 19/01/2022.
    public static let title = L10n.tr("Settings", "title", fallback: "Settings")
    /// WireGuard
    public static let wireGuard = L10n.tr("Settings", "wireGuard", fallback: "WireGuard")
    public enum Dns {
      /// Custom
      public static let custom = L10n.tr("Settings", "DNS.custom", fallback: "Custom")
      /// Default
      public static let `default` = L10n.tr("Settings", "DNS.default", fallback: "Default")
      /// Save
      public static let save = L10n.tr("Settings", "DNS.save", fallback: "Save")
      /// DNS Settings
      public static let title = L10n.tr("Settings", "DNS.title", fallback: "DNS Settings")
      public enum Custom {
        /// Primary DNS
        public static let primaryDNS = L10n.tr("Settings", "DNS.custom.primaryDNS", fallback: "Primary DNS")
        /// Secondary DNS
        public static let secondaryDNS = L10n.tr("Settings", "DNS.custom.secondaryDNS", fallback: "Secondary DNS")
        /// Custom DNS server
        public static let title = L10n.tr("Settings", "DNS.custom.title", fallback: "Custom DNS server")
      }
      public enum Default {
        /// Use default gateway on remote network
        public static let content = L10n.tr("Settings", "DNS.default.content", fallback: "Use default gateway on remote network")
      }
    }
    public enum Tools {
      /// CyberSec
      public static let cyberSec = L10n.tr("Settings", "Tools.cyberSec", fallback: "CyberSec")
      /// Dark Web Monitors
      public static let darkWebMonitors = L10n.tr("Settings", "Tools.darkWebMonitors", fallback: "Dark Web Monitors")
      /// Kill Switch
      public static let killSwitch = L10n.tr("Settings", "Tools.killSwitch", fallback: "Kill Switch")
      /// Tapjacking protection
      public static let tapJackingProtection = L10n.tr("Settings", "Tools.tapJackingProtection", fallback: "Tapjacking protection")
      /// Tools
      public static let title = L10n.tr("Settings", "Tools.title", fallback: "Tools")
      public enum CyberSec {
        /// Protects you from cyber threats by blocking malicious website.
        public static let note = L10n.tr("Settings", "Tools.cyberSec.note", fallback: "Protects you from cyber threats by blocking malicious website.")
      }
      public enum DarkWebMonitors {
        /// Sends alerts if your credentials get publicly exposed online.
        public static let note = L10n.tr("Settings", "Tools.darkWebMonitors.note", fallback: "Sends alerts if your credentials get publicly exposed online.")
      }
      public enum KillSwitch {
        /// Blocks unprotected traffic if VPN connection drops.
        public static let note = L10n.tr("Settings", "Tools.killSwitch.note", fallback: "Blocks unprotected traffic if VPN connection drops.")
      }
      public enum TapJackingProtection {
        /// Warns you if a malicous app adds a screen overlay to trick you into unintended action.
        public static let note = L10n.tr("Settings", "Tools.tapJackingProtection.note", fallback: "Warns you if a malicous app adds a screen overlay to trick you into unintended action.")
      }
    }
  }
  public enum StaticIP {
    /// CURRENT LOAD
    public static let currentLoad = L10n.tr("StaticIP", "CurrentLoad", fallback: "CURRENT LOAD")
    /// StaticIP.strings
    ///   SysVPN
    /// 
    ///   Created by Da Phan Van on 21/02/2022.
    public static let staticIP = L10n.tr("StaticIP", "StaticIP", fallback: "Static ip")
  }
  public enum SubscriptionIntro {
    /// Blazing-fast & stable globally servers network
    public static let cashback = L10n.tr("SubscriptionIntro", "cashback", fallback: "Blazing-fast & stable globally servers network")
    /// Continue without subscription
    public static let continueWithoutSub = L10n.tr("SubscriptionIntro", "continueWithoutSub", fallback: "Continue without subscription")
    /// 24/7 live customer support
    public static let liveSupport = L10n.tr("SubscriptionIntro", "liveSupport", fallback: "24/7 live customer support")
    /// Auto-renewable subscription info:
    /// 
    /// The payment will be charged to your Play Store Account at confirmation of purchase
    /// 
    /// The subscription renews automatically unless the auto-renew is turned off at least 24 hours before the end of the current billing period
    /// 
    /// Yout account will be charged for renewal within 24 hours prior to the end of your selected subscription
    /// 
    /// You can manager subscription and turn off auto-renewal after purchase by going to your Account Settings
    public static let note = L10n.tr("SubscriptionIntro", "note", fallback: "Auto-renewable subscription info:\n\nThe payment will be charged to your Play Store Account at confirmation of purchase\n\nThe subscription renews automatically unless the auto-renew is turned off at least 24 hours before the end of the current billing period\n\nYout account will be charged for renewal within 24 hours prior to the end of your selected subscription\n\nYou can manager subscription and turn off auto-renewal after purchase by going to your Account Settings")
    /// Blazing-fast & stable globally servers network
    public static let rocketFast = L10n.tr("SubscriptionIntro", "rocketFast", fallback: "Blazing-fast & stable globally servers network")
    /// Start your 7-day free trial
    public static let startFreeTrial = L10n.tr("SubscriptionIntro", "startFreeTrial", fallback: "Start your 7-day free trial")
    /// strings
    ///   SysVPN
    /// 
    ///   Created by Nguyễn Đình Thạch on 13/01/2022.
    public static let title = L10n.tr("SubscriptionIntro", "Title", fallback: "Subscription")
    /// One account for All your devices
    public static let unlimited = L10n.tr("SubscriptionIntro", "unlimited", fallback: "One account for All your devices")
  }
  public enum Welcome {
    /// Now you can connect to VPN and enjoy
    /// ultimate privacy and security online.
    public static let message = L10n.tr("Welcome", "message", fallback: "Now you can connect to VPN and enjoy\nultimate privacy and security online.")
    /// Setup Now
    public static let setupButton = L10n.tr("Welcome", "setupButton", fallback: "Setup Now")
    /// Setup Your VPN
    public static let setupVPN = L10n.tr("Welcome", "setupVPN", fallback: "Setup Your VPN")
    /// Your device will ask permission to complete the configuration.
    public static let setupVPNMessage = L10n.tr("Welcome", "setupVPNMessage", fallback: "Your device will ask permission to complete the configuration.")
    /// Start Protecting Yourself
    public static let startButton = L10n.tr("Welcome", "startButton", fallback: "Start Protecting Yourself")
    /// strings
    ///   SysVPN
    /// 
    ///   Created by Nguyễn Đình Thạch on 18/01/2022.
    public static let title = L10n.tr("Welcome", "title", fallback: "Welcome to SysVPN")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
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
