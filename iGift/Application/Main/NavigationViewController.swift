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
        view.backgroundColor = UIColor.fromHex(HexColors.PRIMARY_COLOR.rawValue)
    }

    func setupStatusBar() {
        // Add solid color to the background of the status bar otherwise transparent
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor.fromHex(HexColors.PRIMARY_COLOR.rawValue)
        statusBarView.backgroundColor = statusBarColor
        statusBarView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        view.addSubview(statusBarView)
    }

    func loadInitialView() {
        if (PreferenceUtil.instance.get(key: PreferenceUtil.PHONE_NUMBER).isEmpty) {
            let view = TermsOfUseViewController(nibName: "TermsOfUseViewController", bundle: nil)
            self.pushViewController(view, animated: true)
        } else if(PreferenceUtil.instance.get(key: PreferenceUtil.QUESTION1).isEmpty) {
            let view = SecurityQuestionsViewController(nibName: "SecurityQuestionsViewController", bundle: nil)
            self.pushViewController(view, animated: true)
        } else {
            let view = HomeViewController(nibName: "HomeViewController", bundle: nil)
            self.pushViewController(view, animated: true)
        }
    }
}
