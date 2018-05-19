//
//  AddAccountInfoViewController.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/9/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class VerifyAccountViewController : BaseViewController {
    
    var account: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }

    func setupUi() {
        self.title = "Verify account"
    }

    @IBAction func onOKClicked(_ sender: Any) {
        // push senz to add account
        
        // save account
        
        // save account status
        
        self.loadView("ConfirmAccountViewController")
    }
    
    @IBAction func onCancelClicked(_ sender: Any) {
        //cancel button functionality
    }
}

