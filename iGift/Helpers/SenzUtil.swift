//
//  SenzUtil.swift
//  iGift
//
//  Created by eranga on 5/9/18.
//  Copyright © 2018 eranga. All rights reserved.
//

import Foundation

class SenzUtil {
    static let instance = SenzUtil()
    
    func parse(msg: String) -> Senz {
        let tokens = msg.components(separatedBy: " ")
        let senz = Senz()
        
        for var i in 0 ..< tokens.count {
            let token = tokens[i]
            if(i == 0) {
                senz.type = token
            } else if(i == tokens.count - 1) {
                senz.signature = token
            } else if(token.hasPrefix("@")) {
                senz.receiver = token
            } else if(token.hasPrefix("^")) {
                senz.sender = token
            } else if token.hasPrefix("#") {
                let key = token
                let nxtTkn = tokens[i + 1]
                if nxtTkn.hasPrefix("#") || nxtTkn.hasPrefix("@") {
                    print(key)
                    senz.attr[key] = ""
                } else{
                    print(key + " " + nxtTkn)
                    senz.attr[key] = nxtTkn
                    i += 1
                }
            }
        }
        
        print(senz)
        return senz
    }
    
    func regSenz(uid: String, zAddress: String) -> String? {
        let pubkey = PreferenceUtil.instance.get(key: PreferenceUtil.PUBLIC_KEY)
        let devId = PreferenceUtil.instance.get(key: PreferenceUtil.DEVICE_ID)
        let senz = "SHARE" +
            " #uid " + uid +
            " #pubkey " + pubkey +
            " #dev " + "apple" +
            " #devid " + devId
            " @" + "senzswitch" +
            " ^" + zAddress
        let signature = CryptoUtil.instance.sign(payload: senz)
        return senz + " " + signature
    }
    
    func connectSenz(to: String) -> String {
        let pubkey = PreferenceUtil.instance.get(key: PreferenceUtil.PUBLIC_KEY)
        let zAddress = PreferenceUtil.instance.get(key: PreferenceUtil.Z_ADDRESS)
        let senz = "SHARE" +
            " #uid " + uid(zAddress: zAddress) +
            " #pubkey " + pubkey +
            " @" + to +
            " ^" + zAddress
        let signature = CryptoUtil.instance.sign(payload: senz)
        return senz + " " + signature
    }
    
    func accountSenz(account: String) -> String {
        let zAddress = PreferenceUtil.instance.get(key: PreferenceUtil.Z_ADDRESS)
        let senz = "SHARE" +
            " #uid " + uid(zAddress: zAddress) +
            " #acc " + account +
            " @" + "sampath" +
            " ^" + zAddress
        let signature = CryptoUtil.instance.sign(payload: senz)
        return senz + " " + signature
    }
    
    func salSenz(salt: String) -> String {
        let zAddress = PreferenceUtil.instance.get(key: PreferenceUtil.Z_ADDRESS)
        let senz = "SHARE" +
            " #uid " + uid(zAddress: zAddress) +
            " #salt " + salt +
            " @" + "sampath" +
            " ^" + zAddress
        let signature = CryptoUtil.instance.sign(payload: senz)
        return senz + " " + signature
    }
    
    func transferSenz(amount: String, blob: String, to: String) -> String {
        let zAddress = PreferenceUtil.instance.get(key: PreferenceUtil.Z_ADDRESS)
        let account = PreferenceUtil.instance.get(key: PreferenceUtil.ACCOUNT)
        let senz = "SHARE" +
            " #uid " + uid(zAddress: zAddress) +
            " #id " + NSUUID().uuidString
            " #amnt " + amount +
            " #blob " + blob +
            " #account " + account +
            " #to " + to +
            " #type " + "TRANSFER" +
            " @" + "sampath" +
            " ^" + zAddress
        let signature = CryptoUtil.instance.sign(payload: senz)
        return senz + " " + signature
    }
    
    func redeemSenz() {
        
    }
    
    func uid(zAddress: String) -> String {
        return zAddress + String(Int(Date().timeIntervalSince1970 * 1000))
    }
}
