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
    @IBOutlet weak var rejectButton: CustomButton!
    var isFirstTimeLoading:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }
    
    func setupUi() {
        self.title = "Terms of use"
        
        if !isFirstTimeLoading {
            acceptButton.isHidden = true
            rejectButton.isHidden = true
        }
    }
    
    @IBAction func acceptAction(_ sender: UIButton) {
        let registerViewController = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
        self.navigationController?.pushViewController(registerViewController, animated: false)
    }
    
    @IBAction func rejectAction(_ sender: UIButton) {
        ViewControllerUtil.showAlert(alertTitle: "Notice", alertMessage: "You have to accept the terms & conditions in order to proceed on iGifts")
    }
}
