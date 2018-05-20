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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }
    
    func setupUi() {
        self.title = "Redeem Gift"
        self.setupStylesForTextFields()
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
        
    }
    
}
