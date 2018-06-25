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

    @IBOutlet weak var btnTermsCon: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }

    func setupUi() {
        navigationController?.navigationBar.topItem?.hidesBackButton = true
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
    
    @IBAction func onTermsNConClicked(_ sender: Any) {
        let view = TermsOfUseViewController(nibName: "TermsOfUseViewController", bundle: nil)
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    @IBAction func onRegisterClicked(_ sender: Any) {
        let notificationAcceptStatus = RegisterViewModel().hasUserAccpetedRemoteNotifications()

        // If user hasn't accept remote notifications, do not proceed with the registration
        if !notificationAcceptStatus {
            RegisterViewModel().askUserToRegisterRemoteNotifications(viewController: self)
            return
        }

        // gengerate key pair
        _ = CryptoUtil.instance.initKeys()
        
        // validate inputs
        // ui fields
        let phn = txtFieldUsername.text!.replacingOccurrences(of: " ", with: "")
        let phnCon = txtFieldConfirmUsername.text!.replacingOccurrences(of: " ", with: "")
        let psw = txtFieldPassword.text!.replacingOccurrences(of: " ", with: "")
        let pswCon = txtFieldConfirmPassword.text!.replacingOccurrences(of: " ", with: "")
        
        // validate inputs
        let returnObj = (ViewControllerUtil.validateRegistration(phn: phn, phnCon: phnCon, psw: psw, pswCon: pswCon))
        if returnObj.0 {
            if let p = PhoneBook.instance.internationalize(phone: phn) {
                let phone = p.replacingOccurrences(of: " ", with: "")
                doReg(phone: phone, password: psw)
            } else {
                ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Invalid phone no")
            }
        } else {
            ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: returnObj.1)
        }
    }
    
    func doReg(phone: String, password: String) {
        // reg
        SenzProgressView.shared.showProgressView((self.navigationController?.view)!)
        DispatchQueue.global(qos: .userInitiated).async {
            let uid = SenzUtil.instance.uid(zAddress: phone)
            let regSenz = SenzUtil.instance.regSenz(uid: uid, zAddress: phone)
            let z = Httpz.instance.pushSenz(senz: regSenz!)
            if z == nil {
                // reg fail
                DispatchQueue.main.async {
                    SenzProgressView.shared.hideProgressView()
                    ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Regaistration fail")
                }
            } else {
                // reg done
                PreferenceUtil.instance.put(key: PreferenceUtil.PHONE_NUMBER, value: phone)
                PreferenceUtil.instance.put(key: PreferenceUtil.PASSWORD, value: password)
                
                DispatchQueue.main.async {
                    SenzProgressView.shared.hideProgressView()
                    let view = SecurityQuestionsViewController(nibName: "SecurityQuestionsViewController", bundle: nil)
                    view.isRegistrationProcess = true
                    self.navigationController?.pushViewController(view, animated: false)
                }
            }
        }
    }
}
