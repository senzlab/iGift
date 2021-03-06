//
//  RedeemViewController.swift
//  iGift
//
//  Created by AnujAroshA on 5/20/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class RedeemViewController: KeyboardScrollableViewController, AlertViewControllerDelegate {
    
    @IBOutlet weak var bankNameTextField: UITextField!
    @IBOutlet weak var accountNoTextField: UITextField!
    @IBOutlet weak var confirmAccountNoTextField: UITextField!
    
    var iGift: Igift? = nil
    var bank: Bank? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }
    
    func setupUi() {
        self.title = "Redeem Gift"
        self.setupStylesForTextFields()
        
        if(bank != nil) {
            bankNameTextField.text = bank!.name

            if bank?.code != "7278" {
                ViewControllerUtil.showAlert(alertTitle: "Notice", alertMessage: "When you redeem igift to other bank accounts a charge of Rs 50.00 will be debited from your igift as the commission")
            }
        }
    };
    
    func setupStylesForTextFields(){
        UITextField.applyStyle(txtField: self.bankNameTextField)
        UITextField.applyStyle(txtField: self.accountNoTextField)
        UITextField.applyStyle(txtField: self.confirmAccountNoTextField)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupStylesForTextFields()
    }
    
    @IBAction func redeemAction(_ sender: UIButton) {
        if (iGift != nil) {
            let acc = accountNoTextField.text!.replacingOccurrences(of: " ", with: "")
            let accCon = confirmAccountNoTextField.text!.replacingOccurrences(of: " ", with: "")
            if (ViewControllerUtil.validateRedeem(bankCode: bank!.code, acc: acc, accCon: accCon)) {
                askPassword(acc: acc)
            } else {
                ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Invalid account")
            }
        } else {
            ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Fail to redeem igift")
        }
    }
    
    func askPassword(acc: String) {
        var enteredPassword:String = ""
        let alertController = UIAlertController(title: "Enter Password", message: "", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Done", style: .default, handler: { alert -> Void in
            let savedPassword = PreferenceUtil.instance.get(key: PreferenceUtil.PASSWORD)
            enteredPassword = alertController.textFields![0].text!
            if savedPassword == enteredPassword {
                self.redeem(acc: acc)
            } else {
                ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Invalid password")
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.isSecureTextEntry = true
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func redeem(acc: String) {
        SenzProgressView.shared.showProgressView((self.navigationController?.view)!)
        DispatchQueue.global(qos: .userInitiated).async {
            let uid = SenzUtil.instance.uid(zAddress: PreferenceUtil.instance.get(key: PreferenceUtil.PHONE_NUMBER))
            let senz = SenzUtil.instance.redeemSenz(iGift: self.iGift!, bank: self.bank!.code, account: acc)
            
            // post to contractz
            let dict = ["Uid": uid, "Msg": senz]
            Httpz.instance.doPost(param: dict, onComplete: {(senzes: [Senz]) -> Void in
                if (senzes.count > 0 && senzes.first!.attr["#status"] == "200") {
                    // success redeem
                    // update database
                    _ = SenzDb.instance.markAsRedeemed(id: self.iGift!.uid, acc: acc)
                    DispatchQueue.main.async {
                        SenzProgressView.shared.hideProgressView()
                        
                        // notification
                        let viewContUtil = ViewControllerUtil()
                        viewContUtil.delegate = self
                        viewContUtil.showAlertWithSingleActions(alertTitle: "Success", alertMessage: "Successfully redeemed igift", viewController: self)
                    }
                } else {
                    // fail
                    DispatchQueue.main.async {
                        // fail to send igift
                        SenzProgressView.shared.hideProgressView()
                        ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Fail to redeem igift")
                    }
                }
            })
        }        
    }
    
    func executeTaskForAction(actionTitle: String) {
        if actionTitle == "OK" {
            DispatchQueue.main.async {
                // back to home
                self.loadView("HomeViewController")
            }
        }
    }
    
}
