//
//  BaseViewController.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/8/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController : UIViewController {

    // Defaults
    var isNavBarHidden = true

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(self.isNavBarHidden, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = self.title
    }

    func setNavBarHidden(_ hide: Bool) {
        self.isNavBarHidden = hide
    }
}
