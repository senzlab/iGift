//
//  SecurityAnswersViewController.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/13/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class SecurityAnswersViewController : KeyboardScrollableViewController {

    @IBOutlet weak var txtFieldAOne: UITextField!
    @IBOutlet weak var txtFieldATwo: UITextField!
    @IBOutlet weak var txtFieldAThree: UITextField!
    
    var resetPassword = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupStylesForTextFields()
    }

    @IBAction func onSaveClicked(_ sender: Any) {
        let q1 = txtFieldAOne.text!.replacingOccurrences(of: " ", with: "")
        let q2 = txtFieldATwo.text!.replacingOccurrences(of: " ", with: "")
        let q3 = txtFieldAThree.text!.replacingOccurrences(of: " ", with: "")
        
        validateQuestions(q1: q1, q2: q2, q3: q3)
    }
    
    func setupUi() {
        self.title = "Answer questions"
        self.setupStylesForTextFields()
    }

    func setupStylesForTextFields(){
        UITextField.applyStyle(txtField: self.txtFieldAOne)
        UITextField.applyStyle(txtField: self.txtFieldATwo)
        UITextField.applyStyle(txtField: self.txtFieldAThree)
    }
    
    func validateQuestions(q1: String, q2: String, q3: String) {
        if (resetPassword) {
            // need to answer two question
            var match = 0
            if (q1 == PreferenceUtil.instance.get(key: PreferenceUtil.QUESTION1)) {
                match = match + 1
            }
            if (q2 == PreferenceUtil.instance.get(key: PreferenceUtil.QUESTION2)) {
                match = match + 1
            }
            if (q3 == PreferenceUtil.instance.get(key: PreferenceUtil.QUESTION3)) {
                match = match + 1
            }
            
            if(match >= 2) {
                // todo navigate password reset
                self.loadView("ResetPasswordViewController")
            } else {
                ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "You need to give correct answers for two questions")
            }
        } else {
            // need to asnwer all questions
            if (ViewControllerUtil.validateQuestions(q1: q1, q2: q2, q3: q3)) {
                PreferenceUtil.instance.put(key: PreferenceUtil.QUESTION1, value: q1)
                PreferenceUtil.instance.put(key: PreferenceUtil.QUESTION2, value: q2)
                PreferenceUtil.instance.put(key: PreferenceUtil.QUESTION3, value: q3)
                
                self.loadView("HomeViewController")
            } else {
                ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "You need to answer all three questions")
            }
        }
    }
}
