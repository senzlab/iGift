//
//  CustomImageView.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/10/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

@IBDesignable
class CustomImageView: UIImageView {
    @IBInspectable var isRoundedCorners: Bool = false {
        didSet {
            if isRoundedCorners {
                self.clipsToBounds = true
                self.layer.cornerRadius = CGFloat(self.frame.height / 2)
            } else {
                self.clipsToBounds = false
                self.layer.cornerRadius = CGFloat(0)
            }
        }
    }
}

