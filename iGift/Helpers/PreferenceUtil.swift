//
//  PreferenceUtil.swift
//  iGift
//
//  Created by eranga on 5/10/18.
//  Copyright © 2018 eranga. All rights reserved.
//

import Foundation

class PreferenceUtil {
    
    static let PUBLIC_KEY = "PUBLIC_KEY"
    static let PRIVATE_KEY = "PRIVATE_KEY"
    
    
    let userDefaults = UserDefaults.standard
    
    func put(key: String, value: String) -> Bool {
        userDefaults.set(value, forKey: key)
        return true
    }
    
    func get(key: String) -> String {
        if let highScore = userDefaults.value(forKey: key) {
            return highScore as! String
        }
        
        return ""
    }
}
