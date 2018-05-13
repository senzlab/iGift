//
//  SecurityQuestionsViewController.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/13/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class SecurityQuestionsViewController : BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }

    func setupUi() {
        self.title = "Security questions"
    }

    @IBAction func onNextClicked(_ sender: Any) {
        self.loadView("SecurityAnswersViewController")
    }

    @IBAction func onCancelClicked(_ sender: Any) {
        self.goBack(animated: true)
    }
}
