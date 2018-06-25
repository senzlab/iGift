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
        DispatchQueue.main.async {
            self.setupStylesForTextFields()
        }
    }

    func setupStylesForTextFields(){
        UITextField.applyStyle(txtField: self.txtFieldAccount)
        UITextField.applyStyle(txtField: self.txtFieldConfirmAccount)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            self.setupStylesForTextFields()
        }
    }

    @IBAction func onAddAccountClicked(_ sender: Any) {
        let acc = txtFieldAccount.text!.replacingOccurrences(of: " ", with: "")
        let accCon = txtFieldConfirmAccount.text!.replacingOccurrences(of: " ", with: "")
        
        // validate account
        if(ViewControllerUtil.validateAccount(acc: acc, accCon: accCon)) {
            let viewController = VerifyAccountViewController(nibName: "VerifyAccountViewController", bundle: nil)
            viewController.account = acc
            self.navigationController?.pushViewController(viewController, animated: false)
        } else {
            ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Invalide input fields")
        }
    }
    
}
