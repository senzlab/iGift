//
//  ContactsViewController.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/8/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import Foundation
import UIKit

class ContactsViewController : BaseViewController {

    @IBOutlet weak var addContactsBtn : UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
         self.setupUi()
    }

    func setupUi() {
        // NavBar
        self.setNavBarHidden(false)
        self.title = "Contacts"

        // Rounded Btn
        addContactsBtn?.layer.shadowColor = UIColor.black.cgColor
        addContactsBtn?.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        addContactsBtn?.layer.masksToBounds = false
        addContactsBtn?.layer.shadowRadius = 1.0
        addContactsBtn?.layer.shadowOpacity = 0.5
        addContactsBtn?.layer.cornerRadius = (addContactsBtn?.frame.width)! / 2

    }

    @IBAction func onAddContactBtnClicked(_ sender: Any) {
        let phoneBookViewController = PhoneBookViewController(nibName: "PhoneBookViewController", bundle: nil)
        self.navigationController?.pushViewController(phoneBookViewController, animated: true)
    }
    

}
