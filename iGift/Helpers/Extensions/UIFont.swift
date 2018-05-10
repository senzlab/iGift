//
//  UIFont.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/9/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import Foundation
import UIKit

extension UIFont{
    func fontWithName(name:String) -> UIFont {
        return UIFont(name: name, size: self.pointSize)!
    }
}
