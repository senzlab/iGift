//
//  RedeemViewController.swift
//  iGift
//
//  Created by AnujAroshA on 5/20/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class RedeemViewController: KeyboardScrollableViewController {
    
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
        }
    }
    
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
            if (ViewControllerUtil.validateAccount(acc: acc, accCon: accCon)) {
                let z = Httpz.instance.pushSenz(senz: SenzUtil.instance.redeemSenz(iGift: iGift!, bank: bank!.code, account: acc))
                if (z == nil) {
                    ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Fail to redeem iGift")
                } else {
                    // verify response
                    if (SenzUtil.instance.verifyStatus(z: z!)) {
                        // success redeem
                        // update database
                        SenzDb.instance.markAsRedeemed(id: iGift!.uid)
                        self.navigationController?.popToRootViewController(animated: true)
                    } else {
                        ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Fail to redeem iGift")
                    }
                }
            } else {
                ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Invalid account")
            }
        } else {
            ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Fail to redeem iGift")
        }
    }
}
