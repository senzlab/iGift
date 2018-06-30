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
    
    var selectedUser: SenzContact!
    
    //    MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
        
        nameValueLabel.text = selectedUser.name
        phnNoValueLabel.text = selectedUser.phone
    }
    
    //    MARK: Supportive methods
    func setupUi() {
        self.title = "User profile"
    }
}
