//
//  SecurityQuestionsViewController.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/13/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class SecurityQuestionsViewController : BaseViewController {
    
    @IBOutlet weak var topLabel: CustomLabel!
    @IBOutlet weak var bottomLabel: CustomLabel!
    @IBOutlet weak var nextButton: CustomButton!
    @IBOutlet weak var cancelButton: CustomButton!
    @IBOutlet weak var cancelBtnHeightConstraint: NSLayoutConstraint!
    var isRegistrationProcess: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }

    func setupUi() {
        self.title = "Security questions"
        
        if isRegistrationProcess {
            cancelButton.isHidden = true
            cancelBtnHeightConstraint.constant = 0
            self.navigationItem.setHidesBackButton(true, animated: false)
        }
    }

    @IBAction func onNextClicked(_ sender: Any) {
        self.loadView("SecurityAnswersViewController")
    }

    @IBAction func onCancelClicked(_ sender: Any) {
        self.goBack(animated: true)
    }
}
