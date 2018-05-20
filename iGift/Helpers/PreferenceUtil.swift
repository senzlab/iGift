//
//  PreferenceUtil.swift
//  iGift
//
//  Created by eranga on 5/10/18.
//  Copyright © 2018 eranga. All rights reserved.
//

import Foundation

class PreferenceUtil {
    static let instance = PreferenceUtil()
    
    static let PUBLIC_KEY = "PUBLIC_KEY"
    static let PRIVATE_KEY = "PRIVATE_KEY"
    static let PHONE_NUMBER = "PHONE_NUMBER"
    static let PASSWORD = "PASSWORD"
    static let DEVICE_ID = "DEVICE_ID"
    static let QUESTION1 = "QUESTION1"
    static let QUESTION2 = "QUESTION2"
    static let QUESTION3 = "QUESTION3"
    static let ACCOUNT = "ACCOUNT"
    static let ACCOUNT_STATUS = "ACCOUNT_STATUS"
    
    let userDefaults = UserDefaults.standard
    
    func put(key: String, value: String) {
        userDefaults.set(value, forKey: key)
    }
    
    func get(key: String) -> String {
        if let highScore = userDefaults.value(forKey: key) {
            return highScore as! String
        }
        
        return ""
    }
}
