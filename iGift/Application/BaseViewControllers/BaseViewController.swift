//
//  BaseViewController.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/8/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class BaseViewController : ApplicationViewController {

    // Defaults
    var isNavBarHidden = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyBoardOnLostFocus()
        self.setEmptyBackButton()

        // Ensure all view controllers frame stays within bounds
        edgesForExtendedLayout = []
    }

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

    func setEmptyBackButton() {
        self.navigationItem.backBarButtonItem =
            UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
