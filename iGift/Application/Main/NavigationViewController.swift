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
        view.backgroundColor = UIColor.fromHex(HexColors.PRIMARY_COLOR.rawValue)
    }

    func loadInitialView() {
        if (PreferenceUtil.instance.get(key: PreferenceUtil.PHONE_NUMBER).isEmpty) {
//            let view = TermsOfUseViewController(nibName: "TermsOfUseViewController", bundle: nil)
//            view.isFirstTimeLoading = true
            let view = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
            self.pushViewController(view, animated: false)
        } else if(PreferenceUtil.instance.get(key: PreferenceUtil.QUESTION1).isEmpty) {
            let view = SecurityQuestionsViewController(nibName: "SecurityQuestionsViewController", bundle: nil)
            view.isRegistrationProcess = true
            self.pushViewController(view, animated: false)
        } else {
            let view = HomeViewController(nibName: "HomeViewController", bundle: nil)
            self.pushViewController(view, animated: false)
        }
    }
}
