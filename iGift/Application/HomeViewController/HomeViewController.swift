//
//  HomeViewController.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/8/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController : BaseViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }

    func setupUi() {
        self.setNavBarHidden(true)
        self.title = "Home"
    }

    @IBAction func onContactsBtnClicked(_ sender: Any) {
        self.loadView("ContactsViewController")
    }

    @IBAction func onSettingsBtnClicked(_ sender: Any) {
        self.loadView("SettingsViewController")
    }

    @IBAction func onSendIGiftsBtnClicked(_ sender: Any) {
        
//        let sendIGiftsViewController = SendIGiftsViewController(nibName: "SendIGiftsViewController", bundle: nil)
//        self.navigationController?.pushViewController(sendIGiftsViewController, animated: true)
        
        let designIGiftViewController = DesignIGiftViewController(nibName: "DesignIGiftViewController", bundle: nil)
        self.navigationController?.pushViewController(designIGiftViewController, animated: true)
    }

    @IBAction func onIGiftsBtnClicked(_ sender: Any) {
        let iGiftsViewController = IGiftsViewController(nibName: "IGiftsViewController", bundle: nil)
        self.navigationController?.pushViewController(iGiftsViewController, animated: true)
    }

}
