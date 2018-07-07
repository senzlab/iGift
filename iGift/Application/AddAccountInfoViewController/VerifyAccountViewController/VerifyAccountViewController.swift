//
//  VerifyAccountViewController.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/9/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class VerifyAccountViewController : BaseViewController {
    
    var account: String? = nil
    
    @IBOutlet weak var cancelButton: CustomButton!
    @IBOutlet weak var cancelBtnHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }

    func setupUi() {
        self.title = "Verify account"
        cancelButton.isHidden = true
        cancelBtnHeightConstraint.constant = 0
    }

    @IBAction func onOKClicked(_ sender: Any) {
        // send request
        SenzProgressView.shared.showProgressView((self.navigationController?.view)!)
        DispatchQueue.global(qos: .userInitiated).async {
            let uid = SenzUtil.instance.uid(zAddress: PreferenceUtil.instance.get(key: PreferenceUtil.PHONE_NUMBER))
            let senz = SenzUtil.instance.accountSenz(uid: uid, account: self.account!)
            
            // post to contractz
            let dict = ["Uid": uid, "Msg": senz]
            Httpz.instance.doPost(param: dict, onComplete: {(senzes: [Senz]) -> Void in
                if (senzes.count > 0 && senzes.first!.attr["#status"] == "200") {
                    // done add account
                    PreferenceUtil.instance.put(key: PreferenceUtil.ACCOUNT, value: self.account!)
                    PreferenceUtil.instance.put(key: PreferenceUtil.ACCOUNT_STATUS, value: "PENDING")
                    DispatchQueue.main.async {
                        SenzProgressView.shared.hideProgressView()
                        self.loadView("ConfirmAccountViewController")
                    }
                } else {
                    // fail
                    DispatchQueue.main.async {
                        SenzProgressView.shared.hideProgressView()
                        ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Fail to verify account")
                    }
                }
            })
        }
    }
    
    @IBAction func onCancelClicked(_ sender: Any) {
        //cancel button functionality
    }
    
}

