//
//  PhoneBookViewController.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/9/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import Foundation
import UIKit

class PhoneBookViewController : BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }

    func setupUi() {
        // NavBar
        self.setNavBarHidden(false)
        self.title = "Phone Book"
    }
    
}
