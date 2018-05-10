//
//  CustomLabel.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/9/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

@IBDesignable
class CustomLabel: UILabel {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.font = self.font.fontWithName(name: Constants.MAIN_FONT_FAMILY.rawValue)
    }
}
