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
class SaltConfirmViewController : KeyboardScrollableViewController {

    @IBOutlet weak var txtFieldTransactionAmt: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }

    func setupUi() {
        self.title = "Confirm Account"
        self.setupStylesForTextFields()
    }

    func setupStylesForTextFields(){
        UITextField.applyStyle(txtField: self.txtFieldTransactionAmt)
        
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupStylesForTextFields()
    }

    @IBAction func onConfirmClicked(_ sender: Any) {
        
        //Account validation
        if self.txtFieldTransactionAmt.text != ""{
            ViewControllerUtil.showAlert(alertTitle: "Nitice", alertMessage: "Message")
            return
        }
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    

}
