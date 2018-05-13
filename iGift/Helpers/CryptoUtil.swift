//
//  CryptoUtil.swift
//  iGift
//
//  Created by eranga on 5/8/18.
//  Copyright © 2018 eranga. All rights reserved.
//

import Foundation
import SwiftyRSA

class CryptoUtil {
    
    static let instance = CryptoUtil()
    
    func initKeys() -> Bool {
        if (PreferenceUtil.instance.get(key: PreferenceUtil.PUBLIC_KEY).isEmpty) {
            do {
                // gegnerate key pair
                let keyPair = try SwiftyRSA.generateRSAKeyPair(sizeInBits: 1024)
                let publicKey = keyPair.publicKey
                let privateKey = keyPair.privateKey
                
                // save in user defaults
                PreferenceUtil.instance.put(key: PreferenceUtil.PUBLIC_KEY, value: try publicKey.base64String())
                PreferenceUtil.instance.put(key: PreferenceUtil.PRIVATE_KEY, value: try privateKey.base64String())
            } catch {
                print("error generating keys")
                return false
            }
            return true
        }
        
        // already setup
        return true
    }
    
    func sign(payload: String) -> String {
        do {
            // get private key
            let privateKey = try PrivateKey(base64Encoded: PreferenceUtil.instance.get(key: PreferenceUtil.PRIVATE_KEY))
            
            // format payload
            let fPaylod = payload.replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "\n", with: "")
                .replacingOccurrences(of: "\r", with: "")
            
            // sign
            let clear = try ClearMessage(string: fPaylod, using: .utf8)
            let signature = try clear.signed(with: privateKey, digestType: .sha256)
            return signature.data.base64EncodedString()
        } catch {
            print("Error signing")
        }
        
        return ""
    }
    
}
