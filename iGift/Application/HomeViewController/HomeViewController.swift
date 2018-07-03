//
//  HomeViewController.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/8/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController : BaseViewController {
    
    var shouldShowSecAnsSavedMsg:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
        
        if shouldShowSecAnsSavedMsg {
            ViewControllerUtil.showAutoDismissAlert(alertTitle: "Notice", alertMessage: "Successfully saved answers")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillDisappear(false)
        
        if isContactRequestSent {
            isContactRequestSent = false
            ViewControllerUtil.showAutoDismissAlert(alertTitle: "Notice", alertMessage: "Contact request has been sent")
        }
    }

    func setupUi() {
        self.setNavBarHidden(true)
        self.title = "Home"
    }

    @IBAction func onContactsBtnClicked(_ sender: Any) {
        let contactsViewController = ContactsViewController(nibName: "ContactsViewController", bundle: nil)
        contactsViewController.forNewIgift = false
        self.navigationController?.pushViewController(contactsViewController, animated: false)
    }

    @IBAction func onSettingsBtnClicked(_ sender: Any) {
        self.loadView("SettingsViewController")
    }

    @IBAction func onSendIGiftsBtnClicked(_ sender: Any) {
        
        if (PreferenceUtil.instance.get(key: PreferenceUtil.ACCOUNT).isEmpty) {
            // no account
            // verified account
            self.loadView("AddAccountInfoViewController")
        } else {
            // have account
            if (PreferenceUtil.instance.get(key: PreferenceUtil.ACCOUNT_STATUS) == "VERIFIED") {
                // verified account
                
                if (SenzDb.instance.hasUsers()) {
                    let contactsViewController = ContactsViewController(nibName: "ContactsViewController", bundle: nil)
                    contactsViewController.forNewIgift = true
                    self.navigationController?.pushViewController(contactsViewController, animated: false)
                }
                else {
                    let noContactViewController = NoContactViewController(nibName: "NoContactViewController", bundle: nil)
                    self.navigationController?.pushViewController(noContactViewController, animated: false)
                }
            }
            else {
                // not verified account
                self.loadView("ConfirmAccountViewController")
            }
        }
    }

    @IBAction func onIGiftsBtnClicked(_ sender: Any) {
        self.loadView("IGiftsViewController")
    }

}
