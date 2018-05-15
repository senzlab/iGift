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
        UITextField.applyStyle(txtField: self.txtFieldPassword)
        UITextField.applyStyle(txtField: self.txtFieldConfirmPassword)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupStylesForTextFields()
    }

    @IBAction func onRegisterClicked(_ sender: Any) {
        
        let notificationAcceptStatus = RegisterViewModel().hasUserAccpetedRemoteNotifications()
        
//        If user hasn't accept remote notifications, do not proceed with the registration
        if !notificationAcceptStatus {
            RegisterViewModel().askUserToRegisterRemoteNotifications(viewController: self)
            return
        }
        
        // gengerate key pair
        // do register
        CryptoUtil.instance.initKeys()
        //doReg()
        self.loadView("SecurityQuestionsViewController")
    }
    
    func doReg() {
        // todo validate input fields
        
        // ui fields
        let zAddress = txtFieldUsername.text
        let password = txtFieldPassword.text
        let confirmPassword = txtFieldConfirmPassword.text
        
        // data
        let uid = SenzUtil.instance.uid(zAddress: zAddress!)
        let regSenz = SenzUtil.instance.regSenz(uid: uid, zAddress: zAddress!)
        let data = [
            "uid": uid,
            "msg": regSenz
        ]
        let url = "http://10.2.2.9:7171/uzers"
        
        // send post
        Httpz.instance.doPost(url: url, param: data, onComplete: {success in
            if success {
                // success request
                self.loadView("SecurityQuestionsViewController")
            } else {
                // fail request
            }
        })
        
    }

}
