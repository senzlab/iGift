//
//  TermsOfUseViewController.swift
//  iGift
//
//  Created by AnujAroshA on 5/15/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class TermsOfUseViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }
    
    func setupUi() {
        self.title = "Terms of use"
    }
    
    @IBAction func acceptAction(_ sender: UIButton) {
        let registerViewController = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
        self.navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    @IBAction func rejectAction(_ sender: UIButton) {
        ViewControllerUtil.showAlert(alertTitle: "Title", alertMessage: "Message")
    }
}
