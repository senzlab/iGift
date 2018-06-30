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
            viewContUtil.showAlertWithSingleActions(alertTitle: "Success", alertMessage: "Successfully changed password", viewController: self)
        } else {
            // error
            if validationStatusNum == 2 {
                ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Mismatching password and confirm password")
            }
            else {
                ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Invalid password. Password should contains more than 7 characters with special character")
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
