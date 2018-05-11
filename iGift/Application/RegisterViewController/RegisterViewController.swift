//
//  RegisterViewController.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/11/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

// Class that load all view controllers on the main thread
class RegisterViewController : BaseViewController {
    @IBOutlet weak var txtFieldUsername: UITextField!

    @IBOutlet weak var txtFieldPassword: UITextField!

    @IBOutlet weak var txtFieldConfirmPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }

    func setupUi() {
        self.setNavBarHidden(false)
        self.title = "Register"
        UITextField.applyStyle(txtField: self.txtFieldUsername)
        UITextField.applyStyle(txtField: self.txtFieldPassword)
        UITextField.applyStyle(txtField: self.txtFieldConfirmPassword)
    }

    @IBAction func onRegisterClicked(_ sender: Any) {
        self.loadView("HomeViewController")
    }

}
