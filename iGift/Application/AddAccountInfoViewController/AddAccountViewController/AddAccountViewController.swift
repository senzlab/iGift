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
        
        //Account validation
        if self.txtFieldAccount.text != self.txtFieldConfirmAccount.text{
            ViewControllerUtil.showAlert(alertTitle: "Nitice", alertMessage: "Message")
            return
        }
        
        self.loadView("VerifyAccountViewController")
        
//        let viewController = getNewInstance("ConfirmAccountViewController")  as? ConfirmAccountViewController
//        if let controller = viewController {
//            controller.accountNo = txtFieldConfirmAccount.text
//            DispatchQueue.main.async {
//                self.navigationController?.pushViewController(controller, animated: true)
//            }
//        } else {
//            print("Trying to load an unregistered view controller. Please look into ApplicationViewController class to register view controller")
//        }
        
    }
    

}
