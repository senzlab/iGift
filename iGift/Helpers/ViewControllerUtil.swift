//
//  ViewControllerUtil.swift
//  iGift
//
//  Created by Isuru_Jayathissa on 5/15/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

protocol AlertViewControllerDelegate: class {
    func executeTaskForAction(actionTitle : String)
}

class ViewControllerUtil: NSObject {
    
    weak var delegate : AlertViewControllerDelegate?

    class func showAlert(alertTitle:String, alertMessage:String){
        let perent: UIViewController = (UIApplication.shared.delegate as! AppDelegate).window!.rootViewController!
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        perent.showDetailViewController(alert, sender: nil)
    }
    
    class func showAutoDismissAlert(alertTitle:String, alertMessage:String) {
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let perent: UIViewController = (UIApplication.shared.delegate as! AppDelegate).window!.rootViewController!
        perent.present(alertController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
    func showAlertWithTwoActions(alertTitle:String, alertMessage:String, viewController: UIViewController) {
        let alertController = UIAlertController(title:alertTitle, message:alertMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            self.callDelegate(title: "OK")
        }
        let cancelAction = UIAlertAction(title: "CANCEL", style: .default) { (action:UIAlertAction) in
            self.callDelegate(title: "CANCEL")
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertWithSingleActions(alertTitle:String, alertMessage:String, viewController: UIViewController) {
        
        let alertController = UIAlertController(title:alertTitle, message:alertMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            self.callDelegate(title: "OK")
        }
        
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    static func isValidPassword(testStr:String?) -> Bool {
        guard testStr != nil else { return false }
        
        // at least one symbol,
        // 8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[!&^%$#@()/]+.*).{7,}")
        return passwordTest.evaluate(with: testStr)
    }
    
    static func isValidPhoneNo(testStr:String?) -> Bool {
        guard testStr != nil else { return false }
        
        if testStr?.count != 10{
            return false
        }
        
        if testStr?.first != "0"{
            return false
        }
        
        return true
    }
    
    class func validateRegistration(phn: String, phnCon: String, psw: String, pswCon: String) -> (Bool,String) {
        if phn.count != 10 || phnCon.count != 10 || phn.first != "0" || phnCon.first != "0" {
            return (false,"Invalid phone no. Phone no should contains 10 digits and start with 07")
        }
        
        if(phn != phnCon) {
            // mismatch phone
            return (false,"Mismatching Phone no and confirm Phone no")
        }
        
        if !isValidPassword(testStr: psw){
            // at least one symbol,
            // 8 characters total
            return (false,"Invalid password. Password should contains more than 7 characters with special character")
        }
        
        if(psw != pswCon) {
            // mismatch password
            return (false,"Mismatching password and confirm password")
        }
        
        return (true,"")
    }
    
    class func validateAccount(acc: String, accCon: String) -> Bool {
        if(acc.isEmpty || accCon.isEmpty) {
            // emapty
            return false
        }
        
        if(acc != accCon) {
            // mismatch phone
            return false
        }
        
        if(acc.count != 12) {
            // account should be 12 lenght
            return false
        }
        
        return true
    }
    
    class func validateRedeem(bankCode: String, acc: String, accCon: String) -> Bool {
        if(acc.isEmpty || accCon.isEmpty) {
            // emapty
            return false
        }
        
        if(acc != accCon) {
            // mismatch phone
            return false
        }
        
        if (bankCode == "7278") {
            // sampath, 12 digit acc
            if(acc.count != 12) {
                // account should be 12 lenght
                return false
            }
        } else {
            // other banks, at least 8 digit acc
            if(acc.count < 8) {
                // account should be 12 lenght
                return false
            }
        }
        
        return true
    }
    
    class func validateIGift(amount: String, message: String) -> Int {
        if Int(amount)! < 100 {
            return -1
        }
        
        if Int(amount)! > 10000 {
            return -2
        }
        
        if amount.isEmpty {
            return -3
        }
        
        if message.isEmpty {
            return -4
        }
        
        return 0
    }
    
    class func validateQuestions(q1: String, q2: String, q3: String) -> Bool {
        if (q1.isEmpty || q2.isEmpty || q3.isEmpty) {
            return false
        }
        
        return true
    }
    
    class func validateSalt(salt: String) -> Bool {
        if(salt.isEmpty) {
            return false
        }
        
        return true
    }
    
    class func validateChangePassword(psw: String, pswNew: String, pswCon: String) -> Int {
        if !isValidPassword(testStr: pswNew) {
            return 6
        }
        
        if pswNew == PreferenceUtil.instance.get(key: PreferenceUtil.PASSWORD)  {
            return 5
        }
        
        if (psw.isEmpty || pswCon.isEmpty || pswNew.isEmpty) {
            return 4
        }
        
        if (psw != PreferenceUtil.instance.get(key: PreferenceUtil.PASSWORD)) {
            return 3
        }
        
        if (pswNew != pswCon) {
            return 2
        }
        
        return 1
    }
    
    class func validateResetPassword(psw: String, pswCon: String) -> Int {
        if !isValidPassword(testStr: psw) {
            return 6
        }
        
        if (psw.isEmpty || pswCon.isEmpty) {
            return 4
        }
        
        if (psw != pswCon) {
            return 2
        }
        
        return 1
    }
    
    func callDelegate(title: String) {
        delegate?.executeTaskForAction(actionTitle : title)
    }
}
