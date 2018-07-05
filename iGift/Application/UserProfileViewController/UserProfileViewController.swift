//
//  UserProfileViewController.swift
//  iGift
//
//  Created by AnujAroshA on 6/30/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class UserProfileViewController: BaseViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameValueLabel: UILabel!
    @IBOutlet weak var phnNoValueLabel: UILabel!
    
    var user: User!
    
    // MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
        
        phnNoValueLabel.text = user.phone
        let senzContact = PhoneBook.instance.getContact(phone: user.phone)
        if senzContact != nil {
            nameValueLabel.text = senzContact?.name
        } else {
            nameValueLabel.text = senzContact?.name
        }
    }
    
    //    MARK: Supportive methods
    func setupUi() {
        self.title = "User profile"
    }
}
