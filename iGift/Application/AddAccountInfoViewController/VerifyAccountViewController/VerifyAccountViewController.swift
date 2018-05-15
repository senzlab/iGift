//
//  AddAccountInfoViewController.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/9/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class VerifyAccountViewController : BaseViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }

    func setupUi() {
    
        self.title = "Verify account"
    }

    @IBAction func onOKClicked(_ sender: Any) {
        self.loadView("SaltConfirmViewController")
    }
    
    @IBAction func onCancelClicked(_ sender: Any) {
        //cancel button functionality
    }
}

