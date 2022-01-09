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
}


