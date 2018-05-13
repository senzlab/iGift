//
//  UITextField.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/11/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

extension UITextField {
    class func applyStyle(
        txtField: UITextField,
        borderWidth: Float = 1.0,
        borderColor: UIColor = UIColor.white,
        textColor: UIColor = UIColor.white,
        placeHolderColor: UIColor = UIColor.white,
        fontFamily: String = Constants.MAIN_FONT_FAMILY.rawValue) {

        // Apply Border
        let border = CALayer()
        let width = CGFloat(borderWidth)
        border.borderColor = borderColor.cgColor
        border.frame = CGRect(x: 0, y: txtField.frame.size.height - width, width:  txtField.frame.size.width, height: txtField.frame.size.height)
        border.borderWidth = width
        txtField.layer.addSublayer(border)
        txtField.layer.masksToBounds = true

        // Set Cursor Color
        txtField.tintColor = textColor

        // Set font
        txtField.font = txtField.font?.fontWithName(name: fontFamily)

        // Set Placeholder style
        if let placeholder = txtField.placeholder {
        txtField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                            attributes: [NSAttributedStringKey.foregroundColor: placeHolderColor.withAlphaComponent(0.7),
                                                                         NSAttributedStringKey.font : txtField.font!])
        }
    }
}
