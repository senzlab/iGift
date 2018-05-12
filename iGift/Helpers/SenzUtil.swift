//
//  SenzUtil.swift
//  iGift
//
//  Created by eranga on 5/9/18.
//  Copyright © 2018 eranga. All rights reserved.
//

import Foundation

class SenzUtil {
    func parse(msg: String) -> Senz? {
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
    
    func regSenz(fromZaddress: String, toZaddress: String, pubkey: String) -> String {
        let uid = fromZaddress + String(Int(Date().timeIntervalSince1970 * 1000))
        let senz = "SHARE" +
            " #uid " + uid +
            " #pubkey " + pubkey +
            " @" + toZaddress +
            " ^" + fromZaddress
        
        return senz
    }
    
}
