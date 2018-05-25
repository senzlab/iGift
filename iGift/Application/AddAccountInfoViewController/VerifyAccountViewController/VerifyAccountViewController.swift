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
        SenzProgressView.shared.showProgressView((self.navigationController?.view)!)
        DispatchQueue.global(qos: .userInitiated).async {
            let z = Httpz.instance.pushSenz(senz: SenzUtil.instance.accountSenz(account: self.account!))
            if (z == nil) {
                // fail to add account
                SenzProgressView.shared.hideProgressView()
                ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Fail to add account")
            } else {
                // verify response
                if (SenzUtil.instance.verifyStatus(z: z!)) {
                    // done add account
                    SenzProgressView.shared.hideProgressView()
                    PreferenceUtil.instance.put(key: PreferenceUtil.ACCOUNT, value: self.account!)
                    PreferenceUtil.instance.put(key: PreferenceUtil.ACCOUNT_STATUS, value: "PENDING")
                    self.loadView("ConfirmAccountViewController")
                } else {
                    SenzProgressView.shared.hideProgressView()
                    ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Fail to verify account")
                }
            }
        }
    }
    
    @IBAction func onCancelClicked(_ sender: Any) {
        //cancel button functionality
    }
}

