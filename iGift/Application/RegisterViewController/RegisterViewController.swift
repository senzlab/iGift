//
//  RegisterViewController.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/11/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import Foundation
import UIKit
import Foundation

// Class that load all view controllers on the main thread
class RegisterViewController : KeyboardScrollableViewController {

    @IBOutlet weak var txtFieldUsername: UITextField!
    @IBOutlet weak var txtFieldConfirmUsername: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var txtFieldConfirmPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }

    func setupUi() {
        self.title = "Register"
        self.setupStylesForTextFields()
    }

    func setupStylesForTextFields(){
        UITextField.applyStyle(txtField: self.txtFieldUsername)
        UITextField.applyStyle(txtField: self.txtFieldConfirmUsername)
        UITextField.applyStyle(txtField: self.txtFieldPassword)
        UITextField.applyStyle(txtField: self.txtFieldConfirmPassword)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupStylesForTextFields()
    }

    @IBAction func onRegisterClicked(_ sender: Any) {
        let notificationAcceptStatus = RegisterViewModel().hasUserAccpetedRemoteNotifications()

        // If user hasn't accept remote notifications, do not proceed with the registration
        if !notificationAcceptStatus {
            RegisterViewModel().askUserToRegisterRemoteNotifications(viewController: self)
            return
        }

        // gengerate key pair
        // do register
        CryptoUtil.instance.initKeys()
        doReg()
    }
    
    func doReg() {
        // ui fields
        let phoneNo = txtFieldUsername.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = txtFieldPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmPassword = txtFieldConfirmPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // todo validate input fileds
        if let phn = PhoneBook.instance.internationalize(phone: phoneNo!) {
            // reg
            let uid = SenzUtil.instance.uid(zAddress: phn.replacingOccurrences(of: " ", with: ""))
            let regSenz = SenzUtil.instance.regSenz(uid: uid, zAddress: phn.replacingOccurrences(of: " ", with: ""))
            let z = Httpz.instance.pushSenz(senz: regSenz!)
            if z == nil {
                // reg fail
                ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Regaistration fail")
            } else {
                // reg done
                PreferenceUtil.instance.put(key: PreferenceUtil.PHONE_NUMBER, value: self.txtFieldUsername.text!)
                self.loadView("SecurityQuestionsViewController")
            }
        } else {
            ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Invalid phone no")
        }
    }
}
