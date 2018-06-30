//
//  ResetPasswordViewController.swift
//  iGift
//
//  Created by Frisq on 5/25/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class ResetPasswordViewController: KeyboardScrollableViewController, AlertViewControllerDelegate {
    
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
        
        let validationStatusNum = ViewControllerUtil.validateResetPassword(psw: psw, pswCon: pswCon)
        if(validationStatusNum == 1) {
            // save current password
            PreferenceUtil.instance.put(key: PreferenceUtil.PASSWORD, value: pswCon)
            
            let viewContUtil = ViewControllerUtil()
            viewContUtil.delegate = self
            viewContUtil.showAlertWithSingleActions(alertTitle: "Notice", alertMessage: "Successfully changed password", viewController: self)
        } else {
            // error
            if validationStatusNum == 6 {
                ViewControllerUtil.showAlert(alertTitle: "Notice", alertMessage: "Invalid password. Password must include at least one symbol and be 7 or more characters long.")
            }
            else if validationStatusNum == 5 {
                ViewControllerUtil.showAlert(alertTitle: "Notice", alertMessage: "You cannot enter existing password as new password")
            }
            else if validationStatusNum == 4 {
                ViewControllerUtil.showAlert(alertTitle: "Notice", alertMessage: "You cannot have empty fields")
            }
            else if validationStatusNum == 3 {
                ViewControllerUtil.showAlert(alertTitle: "Notice", alertMessage: "Current password is not matching")
            }
            else if validationStatusNum == 2 {
                ViewControllerUtil.showAlert(alertTitle: "Notice", alertMessage: "New password and confirmation password is not matching")
            }
            else {
                ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Fail to chnage password")
            }
        }
    }
    
    //    MARK : AlertViewControllerDelegate
    func executeTaskForAction(actionTitle: String) {
        if actionTitle == "OK" {
            DispatchQueue.main.async {
                // back to home
                self.loadView("HomeViewController")
            }
        }
    }
}
