//
//  CustomIGiftCell.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/13/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class CustomIGiftCell: UITableViewCell {
    @IBOutlet weak var lblName          : CustomLabel?
    @IBOutlet weak var lblTime          : CustomLabel?
    @IBOutlet weak var lblAmount        : CustomLabel?
    @IBOutlet weak var btnRedeem        : CustomButton?
    @IBOutlet weak var lblAccountNo     : CustomLabel?
    @IBOutlet weak var profileImg       : CustomImageView?

    func setRedeem(){
        self.lblAccountNo?.isHidden = true
    }

    func setAccountNo(_ value : String) {
        self.btnRedeem?.isHidden = true

        self.lblAccountNo?.isHidden = false
        self.lblAccountNo?.text = value
    }
}
