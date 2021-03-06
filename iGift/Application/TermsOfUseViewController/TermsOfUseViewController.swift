//
//  TermsOfUseViewController.swift
//  iGift
//
//  Created by AnujAroshA on 5/15/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class TermsOfUseViewController: BaseViewController {

    @IBOutlet weak var acceptButton: CustomButton!
    var isFirstTimeLoading:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }
    
    func setupUi() {
        self.title = "Terms of use"
    }
    
    @IBAction func acceptAction(_ sender: UIButton) {
        self.loadView("RegisterViewController")
    }
    
    @IBAction func rejectAction(_ sender: UIButton) {
        ViewControllerUtil.showAlert(alertTitle: "Notice", alertMessage: "You have to accept the terms & conditions in order to proceed on igifts")
    }
    
}
