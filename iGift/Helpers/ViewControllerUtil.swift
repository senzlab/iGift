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
    
    func callDelegate(title: String) {
        
        delegate?.executeTaskForAction(actionTitle : title)
    }
}
