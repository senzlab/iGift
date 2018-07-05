//
//  NoContactViewController.swift
//  iGift
//
//  Created by AnujAroshA on 7/3/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class NoContactViewController: BaseViewController {

    //    MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }
    
    //    MARK : Action functions
    @IBAction func phoneBookAction(_ sender: UIButton) {
        self.loadView("PhoneBookViewController")
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        goBack(animated: false)
    }
    
    //    MARK: Supportive functions
    func setupUi() {
        self.title = "Add Contact"
    }
}
