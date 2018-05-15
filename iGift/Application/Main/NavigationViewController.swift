//
//  NavigationViewController.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/8/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import Foundation
import UIKit

class NavigationViewController : UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
        loadInitialView()
    }

    func setupUi() {
        setupStatusBar()

        // Added to avoid seeing the black background issue when navigating between views
        view.backgroundColor = UIColor.fromHex(HexColors.PRIMARY_COLOR.rawValue)
    }

    func setupStatusBar() {
        // Add solid color to the background of the status bar otherwise transparent.
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor.fromHex(HexColors.PRIMARY_COLOR.rawValue)
        statusBarView.backgroundColor = statusBarColor
        statusBarView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        view.addSubview(statusBarView)
    }

    func loadInitialView() {
        
        let termsOfUseViewController = TermsOfUseViewController(nibName: "TermsOfUseViewController", bundle: nil)
        self.pushViewController(termsOfUseViewController, animated: true)
    }
}
