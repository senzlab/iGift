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
class ChangePasswordViewController : KeyboardScrollableViewController {

    @IBOutlet weak var txtcurrentPassword: UITextField!
    @IBOutlet weak var txtFieldNewPw: UITextField!
    @IBOutlet weak var txtFieldNewConfirmPw: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }

    func setupUi() {
        self.title = "Change Password"
        self.setupStylesForTextFields()
    }

    func setupStylesForTextFields(){
        UITextField.applyStyle(txtField: self.txtcurrentPassword)
        UITextField.applyStyle(txtField: self.txtFieldNewPw)
        UITextField.applyStyle(txtField: self.txtFieldNewConfirmPw)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupStylesForTextFields()
    }

    @IBAction func onAddAccountClicked(_ sender: Any) {
        let psw = txtcurrentPassword.text!.replacingOccurrences(of: " ", with: "")
        let pswNew = txtFieldNewPw.text!.replacingOccurrences(of: " ", with: "")
        let pswCon = txtFieldNewConfirmPw.text!.replacingOccurrences(of: " ", with: "")
        
        if(ViewControllerUtil.validateChangePassword(psw: psw, pswNew: pswNew, pswCon: pswCon)) {
            // save current password
            PreferenceUtil.instance.put(key: PreferenceUtil.PASSWORD, value: pswNew)
            self.loadView("HomeViewController")
        } else {
            // error
            ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Fail to chnage password")
        }
    }
}
