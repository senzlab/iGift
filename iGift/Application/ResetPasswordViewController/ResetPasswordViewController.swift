//
//  ResetPasswordViewController.swift
//  iGift
//
//  Created by Frisq on 5/25/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class ResetPasswordViewController: KeyboardScrollableViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }
    
    func setupUi() {
        self.title = "Reset Password"
        self.setupStylesForTextFields()
    }
    
    func setupStylesForTextFields(){
        UITextField.applyStyle(txtField: self.passwordTextField)
        UITextField.applyStyle(txtField: self.confirmPasswordTextField)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupStylesForTextFields()
    }
    
    @IBAction func updateAction(_ sender: UIButton) {
        let psw = passwordTextField.text!.replacingOccurrences(of: " ", with: "")
        let pswCon = confirmPasswordTextField.text!.replacingOccurrences(of: " ", with: "")
        
        if(ViewControllerUtil.validateResetPassword(psw: psw, pswCon: pswCon)) {
            // save current password
            PreferenceUtil.instance.put(key: PreferenceUtil.PASSWORD, value: pswCon)
            self.loadView("HomeViewController")
        } else {
            ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Fail to chnage password")
        }
    }
}
