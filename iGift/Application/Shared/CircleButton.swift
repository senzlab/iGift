//
//  CircleButton.swift
//  iGift
//
//  Created by AnujAroshA on 5/16/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class CircleButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = CGFloat(self.frame.height / 2)
        self.backgroundColor = UIColor.fromHex(0xF5944E)
    }
}
