//
//  RoundedCornerButton.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/9/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {

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

    @IBInspectable var borderWidth: Float {
        get {
            return self.borderWidth
        }
        set {
            self.layer.borderWidth = CGFloat(newValue)
        }
    }

    @IBInspectable var borderColor: UIColor {
        get {
            return self.borderColor
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }

    @IBInspectable var isShadowUnder: Bool = false {
        didSet {
            self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            self.layer.masksToBounds = false

            if isShadowUnder {
                self.layer.shadowOffset = CGSize(width: 0, height: 3)
                self.layer.shadowOpacity = 1.0
            } else {
                self.layer.shadowOffset = CGSize(width: 0, height: 0)
                self.layer.shadowOpacity = 0.0
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel?.font = self.titleLabel?.font.fontWithName(name: Constants.MAIN_FONT_FAMILY.rawValue)
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if self.isShadowUnder {
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.layer.shadowOpacity = 0.0
            self.titleLabel?.textColor = UIColor.fromHex(HexColors.WHITE_COLOR.rawValue)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if self.isShadowUnder {
            self.layer.shadowOffset = CGSize(width: 0, height: 3)
            self.layer.shadowOpacity = 1.0
            self.titleLabel?.textColor = UIColor.fromHex(HexColors.WHITE_COLOR.rawValue)
        }
    }
}
