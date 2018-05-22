//
//  AddAccountInfoViewController.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/9/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class AddAccountInfoViewController : BaseViewController {
    
    @IBOutlet weak var cancelButton: CustomButton!
    @IBOutlet weak var cancelButtonHeightConstraint: NSLayoutConstraint!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }

    func setupUi() {
        self.title = "Add account"
        cancelButton.isHidden = true
        cancelButtonHeightConstraint.constant = 0
    }

    @IBAction func onAddClicked(_ sender: Any) {
        self.loadView("AddAccountViewController")
    }
    
    @IBAction func onCancelClicked(_ sender: Any) {
        // cancel button functionality
    }
}

