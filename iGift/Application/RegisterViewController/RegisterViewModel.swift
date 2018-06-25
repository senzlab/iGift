//
//  RegisterViewModel.swift
//  iGift
//
//  Created by AnujAroshA on 5/14/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit
import UserNotifications

class RegisterViewModel: NSObject {
    
    var registrationStatus:Bool = true
    
    func hasUserAccpetedRemoteNotifications() -> Bool {
        
        let notificationType = UIApplication.shared.currentUserNotificationSettings!.types
        if notificationType == [] {
            // Notifications are NOT enabled
            return false
        } else {
            // Notifications are Enabled
            return true
        }
    }
    
    func askUserToRegisterRemoteNotifications(viewController: UIViewController) {
        registrationStatus = false
        
        let alertController = UIAlertController(title: "Enable Notification", message: "You have to enable notification for igift app by going to device settings", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            print("You've pressed OK");
        }
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
