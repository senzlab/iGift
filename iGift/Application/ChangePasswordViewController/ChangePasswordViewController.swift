//
//  ChangePasswordViewController.swift
//  iGift
//
//  Created by AnujAroshA on 5/16/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class ChangePasswordViewController: KeyboardScrollableViewController {

    //    MARK: UIViewController related
    override func viewDidLoad() {
        super.viewDidLoad()
        print((#file as NSString).lastPathComponent)
        self.setupUi()
        
    }
    
    //    MARK: Supportive functions
    func setupUi() {
        self.title = "Change Password"
    }
}
