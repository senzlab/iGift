//
//  ViewControllerUtil.swift
//  iGift
//
//  Created by Isuru_Jayathissa on 5/15/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class ViewControllerUtil: NSObject {

    class func showAlert(alertTitle:String, alertMessage:String){
        
        let perent: UIViewController = (UIApplication.shared.delegate as! AppDelegate).window!.rootViewController!
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        perent.showDetailViewController(alert, sender: nil)
        
    }
}
