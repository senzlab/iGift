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
    
    class func validateRegistration(phn: String, phnCon: String, psw: String, pswCon: String) -> Bool {
        if (phn.isEmpty || phnCon.isEmpty || psw.isEmpty || pswCon.isEmpty) {
            // empty fields
            return false
        }
        
        if(phn != phnCon) {
            // mismatch phone
            return false
        }
        
        if(psw != pswCon) {
            // mismatch password
            return false
        }
        
        return true
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
        
        return false
    }
    
    class func validateQuestions(q1: String, q2: String, q3: String) -> Bool {
        if (q1.isEmpty || q2.isEmpty || q3.isEmpty) {
            return false
        }
        
        return true
    }
    
    func callDelegate(title: String) {
        delegate?.executeTaskForAction(actionTitle : title)
    }
    
    class func validateSalt(salt: String) -> Bool {
        if(salt.isEmpty) {
            return false
        }
        
        return true
    }
}
