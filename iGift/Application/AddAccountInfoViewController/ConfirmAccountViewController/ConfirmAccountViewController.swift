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
    var accountNo:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }

    func setupUi() {
        self.LblFirstText.text = "We have done test transaction from '\(accountNo ?? "")' account"
        self.title = "Confirm account"
    }

    @IBAction func onNextClicked(_ sender: Any) {
        self.loadView("VerifyAccountViewController")
    }
    
    @IBAction func onCancelClicked(_ sender: Any) {
        //cancel button functionality
    }
}

