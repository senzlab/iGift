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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupStylesForTextFields()
    }

    @IBAction func onSaveClicked(_ sender: Any) {
        print(self.txtFieldAOne.text!)
        print(self.txtFieldATwo.text!)
        print(self.txtFieldAThree.text!)
        self.loadView("HomeViewController")
        
        PreferenceUtil.instance.put(key: PreferenceUtil.QUESTION1, value: self.txtFieldAOne.text!)
        PreferenceUtil.instance.put(key: PreferenceUtil.QUESTION2, value: self.txtFieldATwo.text!)
        PreferenceUtil.instance.put(key: PreferenceUtil.QUESTION3, value: self.txtFieldAThree.text!)
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
}
