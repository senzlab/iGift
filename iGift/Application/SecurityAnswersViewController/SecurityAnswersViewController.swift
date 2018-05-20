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
        let q1 = txtFieldAOne.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let q2 = txtFieldATwo.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let q3 = txtFieldAThree.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
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
        } else {
            // need to asnwer all questions
            if (ViewControllerUtil.validateQuestions(q1: q1, q2: q2, q3: q3)) {
                ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "You need to aswer all three questions")
            } else {
                PreferenceUtil.instance.put(key: PreferenceUtil.QUESTION1, value: q1)
                PreferenceUtil.instance.put(key: PreferenceUtil.QUESTION2, value: q2)
                PreferenceUtil.instance.put(key: PreferenceUtil.QUESTION3, value: q3)
                
                self.loadView("HomeViewController")
            }
        }
    }
}
