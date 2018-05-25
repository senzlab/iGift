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
class SaltConfirmViewController : KeyboardScrollableViewController {

    @IBOutlet weak var txtFieldTransactionAmt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }

    func setupUi() {
        self.title = "Confirm Account"
        self.setupStylesForTextFields()
    }

    func setupStylesForTextFields(){
        UITextField.applyStyle(txtField: self.txtFieldTransactionAmt)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupStylesForTextFields()
    }

    @IBAction func onConfirmClicked(_ sender: Any) {
        let salt = txtFieldTransactionAmt.text!.replacingOccurrences(of: " ", with: "")
        if(ViewControllerUtil.validateSalt(salt: salt)) {
            saltConfirm(salt: salt)
        } else {
            ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Invlid transaction amount")
        }
    }
    
    func saltConfirm(salt: String) {
        SenzProgressView.shared.showProgressView((self.navigationController?.view)!)
        DispatchQueue.global(qos: .userInitiated).async {
            let z = Httpz.instance.pushSenz(senz: SenzUtil.instance.salSenz(salt: salt))
            if (z == nil) {
                DispatchQueue.main.async {
                    SenzProgressView.shared.hideProgressView()
                    ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Fail to verify account")
                }
            } else {
                if (SenzUtil.instance.verifyStatus(z: z!)) {
                    PreferenceUtil.instance.put(key: PreferenceUtil.ACCOUNT_STATUS, value: "VERIFIED")
                    
                    DispatchQueue.main.async {
                        SenzProgressView.shared.hideProgressView()
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    DispatchQueue.main.async {
                        SenzProgressView.shared.hideProgressView()
                        ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Fail to verify account")
                    }
                }
            }
        }
    }
}
