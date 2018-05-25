//
//  AddAccountInfoViewController.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/9/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class ConfirmAccountViewController : BaseViewController {

    @IBOutlet weak var LblFirstText: CustomLabel!
    @IBOutlet weak var cancelButton: CustomButton!
    @IBOutlet weak var cancelBtnHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }

    func setupUi() {
        self.title = "Confirm account"
        cancelButton.isHidden = true
        cancelBtnHeightConstraint.constant = 0
    }

    @IBAction func onNextClicked(_ sender: Any) {
        self.loadView("SaltConfirmViewController")
    }
    
    @IBAction func onCancelClicked(_ sender: Any) {
        //cancel button functionality
    }
}

