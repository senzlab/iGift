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
        let contactsViewController = ContactsViewController(nibName: "ContactsViewController", bundle: nil)
        contactsViewController.forNewIgift = false
        self.navigationController?.pushViewController(contactsViewController, animated: true)
    }

    @IBAction func onSettingsBtnClicked(_ sender: Any) {
        self.loadView("SettingsViewController")
    }

    @IBAction func onSendIGiftsBtnClicked(_ sender: Any) {
        let contactsViewController = ContactsViewController(nibName: "ContactsViewController", bundle: nil)
        contactsViewController.forNewIgift = true
        self.navigationController?.pushViewController(contactsViewController, animated: true)
    }

    @IBAction func onIGiftsBtnClicked(_ sender: Any) {
        self.loadView("IGiftsViewController")
    }

}
