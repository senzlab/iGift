//
//  ConfirmAccountViewController.swift
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
        self.navigationItem.setHidesBackButton(true, animated:true);
        self.title = "Confirm account"
        LblFirstText.text = "We have tested a transaction from account '\(PreferenceUtil.instance.get(key: PreferenceUtil.ACCOUNT))'."
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

