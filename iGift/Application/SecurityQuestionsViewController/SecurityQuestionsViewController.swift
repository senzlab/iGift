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
        if isRegistrationProcess {
            self.title = "Security questions"
            cancelButton.isHidden = true
            cancelBtnHeightConstraint.constant = 0
            self.navigationItem.setHidesBackButton(true, animated: false)
        } else {
            self.title = "Forgot password"
            topLabel.text = "Did you forget your igift password"
            bottomLabel.text = "You can reset your password by answering two security questions"
            cancelButton.isHidden = true
            cancelBtnHeightConstraint.constant = 0
        }
    }

    @IBAction func onNextClicked(_ sender: Any) {
        let viewController = SecurityAnswersViewController(nibName: "SecurityAnswersViewController", bundle: nil)
        viewController.resetPassword = isRegistrationProcess ? false : true
        self.navigationController?.pushViewController(viewController, animated: false)
    }

    @IBAction func onCancelClicked(_ sender: Any) {
        self.goBack(animated: false)
    }
}
