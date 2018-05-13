//
//  RegisterViewController.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/11/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import Foundation
import UIKit

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
        print(self.txtFieldUsername.text!)
        print(self.txtFieldPassword.text!)
        print(self.txtFieldConfirmPassword.text!)
        self.loadView("SecurityQuestionsViewController")
    }



}
