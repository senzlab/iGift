//
//  AddAccountInfoViewController.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/9/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class AddAccountInfoViewController : BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }

    func setupUi() {
        self.title = "Add account"
    }

    @IBAction func onAddClicked(_ sender: Any) {
        self.loadView("AddAccountViewController")
    }
    
    @IBAction func onCancelClicked(_ sender: Any) {
        // cancel button functionality
    }
}

