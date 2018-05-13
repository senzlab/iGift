//
//  CryptoUtil.swift
//  iGift
//
//  Created by eranga on 5/8/18.
//  Copyright © 2018 eranga. All rights reserved.
//

//import Foundation
//import CommonCrypto
//import SwiftyRSA
//
//class CryptoUtil {
//    let userDefaults = UserDefaults.standard
//
//    func initKeyPair() -> Bool {
//        var publicKey : SecKey?
//        var privateKey : SecKey?
//
////        do {
////            let keyPair = try SwiftyRSA.generateRSAKeyPair(sizeInBits: 1024)
////            let pubk = keyPair.publicKey
////            let base64 = try pubk.base64String()
////            print(base64)
////        } catch {
////            print("errorr")
////        }
//
//        // generate keypair
//        let parameters : [String : AnyObject] = [
//            kSecAttrKeyType as String : kSecAttrKeyTypeRSA,
//            kSecAttrKeySizeInBits as String : 1024 as AnyObject,
//        ]
//
//        let status = SecKeyGeneratePair(parameters as CFDictionary, &publicKey, &privateKey)
//        if status == noErr && publicKey != nil {
//            // save public key
//            if let cfData = SecKeyCopyExternalRepresentation(publicKey!, nil) {
//                let data = cfData as Data
//                let keyStr = data.base64EncodedString()
//                print(keyStr)
//
//                // TODO save public key
//                //userDefaults.set(keyStr, forKey: "PUBLIC_KEY")
//            } else {
//                return false
//            }
//
//            // save private key
//            if let cfData = SecKeyCopyExternalRepresentation(privateKey!, nil) {
//                let data = cfData as Data
//                let keyStr = data.base64EncodedString()
//                print(keyStr)
//
//                // TODO save public key
//                //userDefaults.set(keyStr, forKey: "PRIVATE_KEY")
//            } else{
//                return false
//            }
//
//            // example sign/verify
//            let s = sign(payload: "eranga", key: privateKey!)
//            print(verify(payload: "eranga", signature: s!, key: publicKey!))
//        } else {
//            return false
//        }
//
//        return true
//    }
//
//    func sign(payload: String, key: SecKey) -> String? {
//        // get private key
//
//        // hash payload
//        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
//        let hashBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: digestLength)
//        let data = [UInt8](payload.trimmingCharacters(in: .whitespacesAndNewlines).utf8)
//        CC_SHA256([UInt8](data), CC_LONG(data.count), hashBytes)
//
//        // sign
//        let blockSize = SecKeyGetBlockSize(key)
//        var signatureBytes = [UInt8](repeating:0, count:blockSize)
//        var signatureDataLength = blockSize
//        let status = SecKeyRawSign(key, .PKCS1SHA256, hashBytes, digestLength, &signatureBytes, &signatureDataLength)
//        if status == noErr {
//            let data = Data(bytes: signatureBytes, count: signatureDataLength)
//            return data.base64EncodedString()
//        }
//
//        return nil
//    }
//
//    func verify(payload: String, signature: String, key: SecKey) -> Bool {
//        if let signatureData = Data.init(base64Encoded: signature) {
//            // hash the message first
//            let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
//            let hashBytes = UnsafeMutablePointer<UInt8>.allocate(capacity:digestLength)
//            let data = [UInt8](payload.trimmingCharacters(in: .whitespacesAndNewlines).utf8)
//            CC_SHA256([UInt8](data), CC_LONG(data.count), hashBytes)
//
//            // verify
//            let status = signatureData.withUnsafeBytes {signatureBytes in
//                return SecKeyRawVerify(key, .PKCS1SHA256, hashBytes, digestLength, signatureBytes, signatureData.count)
//            }
//
//            return status == noErr
//        }
//
//        return false
//    }
//
//    func getPubicKey(keyStr: String) -> SecKey? {
//        if let keyData = Data.init(base64Encoded: keyStr) {
//            let parameters : [String : AnyObject] = [
//                kSecAttrKeyType as String : kSecAttrKeyTypeRSA,
//                kSecAttrKeyClass as String : kSecAttrKeyClassPublic,
//                kSecAttrKeySizeInBits as String : 1024 as AnyObject,
//                kSecReturnPersistentRef as String : true as AnyObject
//            ]
//            return SecKeyCreateWithData(keyData as CFData, parameters as CFDictionary, nil)
//        }
//
//        return nil
//    }
//
//    func getPrivateKey(keyStr: String) -> SecKey? {
//        if let keyData = Data.init(base64Encoded: keyStr) {
//            let parameters : [String : AnyObject] = [
//                kSecAttrKeyType as String : kSecAttrKeyTypeRSA,
//                kSecAttrKeyClass as String : kSecAttrKeyClassPrivate,
//                kSecAttrKeySizeInBits as String : 1024 as AnyObject,
//                kSecReturnPersistentRef as String : true as AnyObject
//            ]
//            return SecKeyCreateWithData(keyData as CFData, parameters as CFDictionary, nil)
//        }
//
//        return nil
//    }
//
//}

