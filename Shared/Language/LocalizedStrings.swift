//
//  LocalizedStrings.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 06/12/2021.
//

import Foundation

struct LocalizedStringKey {
    enum Global: String {
        case slogan = "Global.slogan"
        case on = "Global.on"
        case off = "Global.off"
        case stateDefault = "Global.default"
        
        var localized: String {
            return NSLocalizedString(self.rawValue, tableName: "Global", comment: "")
        }
    }
    
    enum Introduction: String {
        case trialButton = "Introduction.trialButton"
        
        case intro1Title = "Introduction.Intro1Title"
        case intro1Body = "Introduction.Intro1Body"
        
        case intro2Title = "Introduction.Intro2Title"
        case intro2Body = "Introduction.Intro2Body"
        
        case intro3Title = "Introduction.Intro3Title"
        case intro3Body = "Introduction.Intro3Body"
        
        var localized: String {
            return NSLocalizedString(self.rawValue, tableName: "Introduction", comment: "")
        }
    }
    
    enum Login: String {
        case title = "Login.Title"
        case body = "Login.Body"
        
        case usernamePlaceholder = "Login.UsernamePlaceholder"
        case passwordPlaceholder = "Login.PasswordPlaceholder"
        case emailPlaceholder = "Login.EmailPlaceholder"
        case signin = "Login.Signin"
        case signinWithGoogle = "Login.SigninWithGoogle"
        case signinWithApple = "Login.SigninWithApple"
        
        case noAccountQuestion = "Login.NoAccountQuestion"
        case createNew = "Login.CreateNew"
        case forgotPassword = "Login.ForgotPassword"
        
        var localized: String {
            return NSLocalizedString(self.rawValue, tableName: "Login", comment: "")
        }
    }
    
    enum Board: String {
        case yourIP = "Board.IP"
        case subIP = "Board.SubIP"
        case unConnect = "Board.Unconnect"
        case connected = "Board.Connected"
        case connecting = "Board.Connecting"
        case titleNavigationNotConnect = "Board.NavigationTitleNotConnect"
        case titleNavigationConnected = "Board.NavigationTitleConnected"
        case titleNavigationConnecting = "Board.NavigationTitleConnecting"
        case locationTab = "Locations"
        case staticIPTab = "Static IP"
        case multiHopTab = "MultiHop"
        case unconnectButton = "Board.QuickUnConnect"
        case connectedAlert = "Board.ConnectedAlert"
        case speed = "Board.Speed"
        case backToMap = "Board.backToMap"
        
        var localized: String {
            return NSLocalizedString(self.rawValue, tableName: "Board", comment: "")
        }
    }
    
    enum Register: String {
        case title = "Register.Title"
        case body = "Register.Body"
        
        case usernamePlaceholder = "Register.UsernamePlaceholder"
        case passwordPlaceholder = "Register.PasswordPlaceholder"
        case emailPlaceholder = "Register.EmailPlaceholder"
        case retypePassword = "Register.RetypePassword"
        
        case signup = "Register.Signup"
        case signupWithGoogle = "Register.SignupWithGoogle"
        case signupWithApple = "Register.SignupWithApple"
        
        case hadAccountText = "Register.HadAccountText"
        case signin = "Register.Signin"
        
        var localized: String {
            return NSLocalizedString(self.rawValue, tableName: "Register", comment: "")
        }
    }
    
    enum ForgotPassword: String {
        case title = "ForgotPassword.Title"
        case body = "ForgotPassword.Body"
        case emailPlaceholder = "ForgotPassword.EmailPlaceholder"
        case sendRequestButton = "ForgotPassword.SendRequestButton"
        
        var localized: String {
            return NSLocalizedString(self.rawValue, tableName: "ForgotPassword", comment: "")
        }
    }
    
    enum Notice: String {
        case title = "Notice.Title"
        case firstGraph = "Notice.FirstGraph"
        case firstTerm = "Notice.FirstTerm"
        case secondTerm = "Notice.SecondTerm"
        case lastGraph = "Notice.LastGraph"
        case buttonText = "Notice.ButtonText"
        var localized: String {
            return NSLocalizedString(self.rawValue, tableName: "Notice", comment: "")
        }
    }
    
    enum SubscriptionIntro: String {
        case title = "SubscriptionIntro.Title"
        case unlimited = "SubscriptionIntro.unlimited"
        case cashback = "SubscriptionIntro.cashback"
        case rocketFast = "SubscriptionIntro.rocketFast"
        case liveSupport = "SubscriptionIntro.liveSupport"
        case startFreeTrial = "SubscriptionIntro.startFreeTrial"
        case continueWithoutSub = "SubscriptionIntro.continueWithoutSub"
        case note = "SubscriptionIntro.note"
        var localized: String {
            return NSLocalizedString(self.rawValue, tableName: "SubscriptionIntro", comment: "")
        }
    }
    
    enum PlanSelect: String {
        case title = "PlanSelect.title"
        case body = "PlanSelect.body"
        case continueButton = "PlanSelect.continueButton"
        case note = "PlanSelect.note"
        case planATitle = "PlanA.title"
        case planADescription = "PlanA.description"
        case planAPrice = "PlanA.price"
        case planASavingText = "PlanA.savingText"
        case planANote = "PlanA.note"
        case planBTitle = "PlanB.title"
        case planBDescription = "PlanB.description"
        case planBPrice = "PlanB.price"
        case planBSavingText = "PlanB.savingText"
        case planBNote = "PlanB.note"
        case planCTitle = "PlanC.title"
        case planCPrice = "PlanC.price"
        case planCDescription = "PlanC.description"
        case planCSavingText = "PlanC.savingText"
        case planCNote = "PlanC.note"
        case month = "PlanSelect.month"
        var localized: String {
            return NSLocalizedString(self.rawValue, tableName: "PlanSelect", comment: "")
        }
    }
    
    enum Welcome: String {
        case title = "Welcome.title"
        case message = "Welcome.message"
        case startButton = "Welcome.startButton"
        case setupVPN = "Welcome.setupVPN"
        case setupVPNMessage = "Welcome.setupVPNMessage"
        case setupButton = "Welcome.setupButton"
        var localized: String {
            return NSLocalizedString(self.rawValue, tableName: "Welcome", comment: "")
        }
    }
    
    enum Account: String {
        case itemAccount = "Account.itemAccount"
        case itemDevices = "Account.itemDevices"
        case itemQuestions = "Account.itemQuestions"
        case itemHelpCenter = "Account.itemHelpCenter"
        case itemSecurity = "Account.itemSecurity"
        case tapControlProfile = "Account.tapControl"
        case sectionAccount = "Account.Account"
        case sectionSupport = "Account.Support"
        case signOut = "Account.signout"
        case titleAccount = "Account.titleAccount"
        case cancelSubscribe = "PaymentHistory.cancelSubscription"
        case contentTotalDevices = "Account.contentTotalDevices"
        
        var localized: String {
            return NSLocalizedString(self.rawValue, tableName: "Account", comment: "")
        }
    }
    
    enum Infomation: String {
        case emailCell = "Infomation.email"
        case memberCell = "Infomation.member"
        case idCell = "Infomation.id"
        case securityCell = "Infomation.security"
        case changePassword = "Infomation.changePassword"
        case introChangePassword = "Infomation.introChangePassword"
        case currentPassword = "Infomation.currentPassword"
        case newPassword = "Infomation.newPassword"
        case retypePassword = "Infomation.retypePassword"
        case save = "Infomation.save"
        case tapToChange = "Infomation.tapToChangePassword"
        case title = "Infomation.title"
        
        var localized: String {
            return NSLocalizedString(self.rawValue, tableName: "Account", comment: "")
        }
    }
    
    enum AccountStatus: String {
        case title = "AccountStatus.title"
        case paymentHistory = "AccountStatus.paymentHistory"
        case tapToShow = "AccountStatus.tapToShow"
        case extendSub = "AccountStatus.extend"
        
        var localized: String {
            return NSLocalizedString(self.rawValue, tableName: "Account", comment: "")
        }
    }
    
    enum Settings: String {
        case title = "Settings.title"
        case sectionVPN = "Settings.sectionVPN"
        case itemVPN = "Settings.itemVPN"
        case itemTool = "Settings.itemTool"
        case itemGeneral = "Settings.itemGeneral"
        case itemApps = "Settings.itemApps"
        case itemProtec = "Settings.itemProtec"
        case itemHelp = "Settings.itemHelp"
        case enabled = "Settings.enabled"
        case disabled = "Settings.disabled"
        case sectionOther = "Settings.sectionOther"
        case settings = "Settings.settings"
        
        
        var localized: String {
            return NSLocalizedString(self.rawValue, tableName: "Settings", comment: "")
        }
    }
    
    enum VPNSetting: String {
        case itemAuto = "Settings.itemAuto"
        case itemProtocol = "Settings.itemProtocol"
        case itemSplit = "Settings.itemSplit"
        case itemDNS = "Settings.itemDNS"
        case itemLocalNetwork = "Settings.itemLocalNetwork"
        case itemMetered = "Settings.itemPMetered"
        case contentItemProtocol = "Settings.contentItemProtocol"
        case contentItemLocalNetwork = "Settings.contentItemLocalNetwork"
        case contentItemMetered = "Settings.contentItemMetered"
        case contentItemSplit = "Settings.contentItemSplit"
        
        case itemAlways = "Settings.alwaysConnect"
        case itemOnWifi = "Settings.onWifiConnect"
        case itemOnMobile = "Settings.onMobileConnect"
        case itemOff = "Settings.offConnect"
        case sectionAuto = "Settings.sectionAutoConnect"
        case itemFaster = "Settings.fastestConnect"
        case contentItemRecommend =  "Settings.contentRecommend"
        
        var localized: String {
            return NSLocalizedString(self.rawValue, tableName: "Settings", comment: "")
        }
    }
    
    enum BoardList: String {
        case search = "BoardList.Search"
        case recentLocation = "BoardList.RecentLocations"
        case recommend = "BoardList.Recommended"
        case all = "BoardList.AllCountries"
        case city = "BoardList.City"
        case cites = "BoardList.Cities"
        case avaiable = "BoardList.Available"
        case singleLocation = "BoardList.SingleLocation"
        
        var localized: String {
            return NSLocalizedString(self.rawValue, tableName: "Board", comment: "")
        }
    }
}


