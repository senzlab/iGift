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
class ChangePasswordViewController : KeyboardScrollableViewController, AlertViewControllerDelegate {

    @IBOutlet weak var txtcurrentPassword: UITextField!
    @IBOutlet weak var txtFieldNewPw: UITextField!
    @IBOutlet weak var txtFieldNewConfirmPw: UITextField!

    //    MARK : UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }

    //    MARK : UIViewController functions
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupStylesForTextFields()
    }

    //    MARK : Action functions
    @IBAction func onAddAccountClicked(_ sender: Any) {
        let psw = txtcurrentPassword.text!.replacingOccurrences(of: " ", with: "")
        let pswNew = txtFieldNewPw.text!.replacingOccurrences(of: " ", with: "")
        let pswCon = txtFieldNewConfirmPw.text!.replacingOccurrences(of: " ", with: "")
        
        let validationStatusNum = ViewControllerUtil.validateChangePassword(psw: psw, pswNew: pswNew, pswCon: pswCon)

        if(validationStatusNum == 1) {
            // save current password
            PreferenceUtil.instance.put(key: PreferenceUtil.PASSWORD, value: pswNew)
            
            let viewContUtil = ViewControllerUtil()
            viewContUtil.delegate = self
            viewContUtil.showAlertWithSingleActions(alertTitle: "Notice", alertMessage: "Successfully changed password", viewController: self)
        }
        else {
            // error
            if validationStatusNum == 6 {
                ViewControllerUtil.showAlert(alertTitle: "Notice", alertMessage: "Invalid password. Password must include at least one symbol and be 7 or more characters long.")
            }
            else if validationStatusNum == 5 {
                ViewControllerUtil.showAlert(alertTitle: "Notice", alertMessage: "You cannot enter existing password as new password")
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
    
    //    MARK: Supportive fucntions
 
    func setupUi() {
        self.title = "Change Password"
        self.setupStylesForTextFields()
    }
    
    func setupStylesForTextFields(){
        UITextField.applyStyle(txtField: self.txtcurrentPassword)
        UITextField.applyStyle(txtField: self.txtFieldNewPw)
        UITextField.applyStyle(txtField: self.txtFieldNewConfirmPw)
    }
}
