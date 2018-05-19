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
                    senz.attr[key] = ""
                } else{
                    senz.attr[key] = nxtTkn
                    i += 1
                }
            }
        }
        
        return senz
    }
    
    func regSenz(uid: String, zAddress: String) -> String? {
        let pubkey = PreferenceUtil.instance.get(key: PreferenceUtil.PUBLIC_KEY)
        let devId = PreferenceUtil.instance.get(key: PreferenceUtil.DEVICE_ID)
        let senz = "PUT" +
            " #uid " + uid +
            " #pubkey " + pubkey +
            " #dev " + "apple" +
            " #devid " + devId +
            " @" + "senzswitch" +
            " ^" + zAddress
        let signature = CryptoUtil.instance.sign(payload: senz)
        return senz + " " + signature
    }
    
    func connectSenz(to: String) -> String {
        let pubkey = PreferenceUtil.instance.get(key: PreferenceUtil.PUBLIC_KEY)
        let zAddress = PreferenceUtil.instance.get(key: PreferenceUtil.PHONE_NUMBER)
        let senz = "SHARE" +
            " #uid " + uid(zAddress: zAddress) +
            " #pubkey " + pubkey +
            " #to " + to +
            " @" + "senzswitch" +
            " ^" + zAddress
        let signature = CryptoUtil.instance.sign(payload: senz)
        return senz + " " + signature
    }
    
    func accountSenz(account: String) -> String {
        let zAddress = PreferenceUtil.instance.get(key: PreferenceUtil.PHONE_NUMBER)
        let senz = "SHARE" +
            " #uid " + uid(zAddress: zAddress) +
            " #acc " + account +
            " @" + "sampath" +
            " ^" + zAddress
        let signature = CryptoUtil.instance.sign(payload: senz)
        return senz + " " + signature
    }
    
    func salSenz(salt: String) -> String {
        let zAddress = PreferenceUtil.instance.get(key: PreferenceUtil.PHONE_NUMBER)
        let senz = "SHARE" +
            " #uid " + uid(zAddress: zAddress) +
            " #salt " + salt +
            " @" + "sampath" +
            " ^" + zAddress
        let signature = CryptoUtil.instance.sign(payload: senz)
        return senz + " " + signature
    }
    
    func transferSenz(amount: String, blob: String, to: String) -> String {
        let zAddress = PreferenceUtil.instance.get(key: PreferenceUtil.PHONE_NUMBER)
        let account = PreferenceUtil.instance.get(key: PreferenceUtil.ACCOUNT)
        let senz = "SHARE" +
            " #uid " + uid(zAddress: zAddress) +
            " #id " + NSUUID().uuidString +
            " #amnt " + amount +
            " #bnk " + "sampath" +
            " #blob " + blob +
            " #acc " + account +
            " #to " + to +
            " #type " + "TRANSFER" +
            " @" + "sampath" +
            " ^" + zAddress
        let signature = CryptoUtil.instance.sign(payload: senz)
        return senz + " " + signature
    }
    
    func redeemSenz() {
        
    }
    
    func blobSenz(uid: String) -> String {
        let zAddress = PreferenceUtil.instance.get(key: PreferenceUtil.PHONE_NUMBER)
        let senz = "GET" +
            " #uid " + uid +
            " @" + "senzswitch" +
            " ^" + zAddress
        let signature = CryptoUtil.instance.sign(payload: senz)
        return senz + " " + signature
    }
    
    func uid(zAddress: String) -> String {
        return zAddress + String(TimeUtil.sharedInstance.timestamp())
    }
    
}
