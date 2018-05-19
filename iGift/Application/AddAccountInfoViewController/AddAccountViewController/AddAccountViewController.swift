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
class AddAccountViewController : KeyboardScrollableViewController {

    @IBOutlet weak var txtFieldAccount: UITextField!
    @IBOutlet weak var txtFieldConfirmAccount: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }

    func setupUi() {
        self.title = "Add Account"
        self.setupStylesForTextFields()
    }

    func setupStylesForTextFields(){
        UITextField.applyStyle(txtField: self.txtFieldAccount)
        UITextField.applyStyle(txtField: self.txtFieldConfirmAccount)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupStylesForTextFields()
    }

    @IBAction func onAddAccountClicked(_ sender: Any) {
        // validate account
        let acc = txtFieldAccount.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let confAcc = txtFieldConfirmAccount.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let viewController = VerifyAccountViewController(nibName: "VerifyAccountViewController", bundle: nil)
        viewController.account = acc
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
