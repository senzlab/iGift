//
//  AddAccountViewController.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/11/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import Foundation
import UIKit
import Foundation

// Class that load all view controllers on the main thread
class SaltConfirmViewController : KeyboardScrollableViewController, AlertViewControllerDelegate {

    @IBOutlet weak var txtFieldTransactionAmt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }

    func setupUi() {
        self.title = "Confirm Account"
        DispatchQueue.main.async {
            self.setupStylesForTextFields()
        }
    }

    func setupStylesForTextFields(){
        UITextField.applyStyle(txtField: self.txtFieldTransactionAmt)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            self.setupStylesForTextFields()
        }
    }

    @IBAction func onConfirmClicked(_ sender: Any) {
        let salt = txtFieldTransactionAmt.text!.replacingOccurrences(of: " ", with: "")
        if(ViewControllerUtil.validateSalt(salt: salt)) {
            saltConfirm(salt: salt)
        } else {
            ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Invlid transaction amount")
        }
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.loadView("HomeViewController")
    }
    
    func saltConfirm(salt: String) {
        // send request
        SenzProgressView.shared.showProgressView((self.navigationController?.view)!)
        DispatchQueue.global(qos: .userInitiated).async {
            let uid = SenzUtil.instance.uid(zAddress: PreferenceUtil.instance.get(key: PreferenceUtil.PHONE_NUMBER))
            let senz = SenzUtil.instance.salSenz(uid: uid, salt: salt)
            
            // post to contractz
            let dict = ["Uid": uid, "Msg": senz]
            Httpz.instance.doPost(param: dict, onComplete: {(senzes: [Senz]) -> Void in
                if (senzes.count > 0 && senzes.first!.attr["#status"] == "200") {
                    // done add account
                    PreferenceUtil.instance.put(key: PreferenceUtil.ACCOUNT_STATUS, value: "VERIFIED")
                    
                    DispatchQueue.main.async {
                        PreferenceUtil.instance.put(key: PreferenceUtil.WRONG_ATTEMPTS, value: String(0))
                        SenzProgressView.shared.hideProgressView()
                        let viewContUtil = ViewControllerUtil()
                        viewContUtil.delegate = self
                        viewContUtil.showAlertWithSingleActions(alertTitle: "Notice", alertMessage: "Successfully added account", viewController: self)
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
    
    // MARK: AlertViewControllerDelegate
    func executeTaskForAction(actionTitle: String) {
        if actionTitle == "OK" {
            DispatchQueue.main.async {
                // back to home
                self.loadView("HomeViewController")
            }
        }
    }
}
