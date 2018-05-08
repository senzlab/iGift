//
//  SettingsViewController.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/8/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController : BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }

    func setupUi() {
        self.setNavBarHidden(false)
        self.title = "Settings"
    }
}
