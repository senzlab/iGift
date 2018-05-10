//
//  ChooseBackgroundViewModel.swift
//  iGift
//
//  Created by AnujAroshA on 5/10/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class ChooseBackgroundViewModel: NSObject {
    
    func colourForTheCell(indexpathNumber: Int) -> UIColor {
        switch indexpathNumber {
        case 0:
            return UIColor.red
        case 1:
            return UIColor.gray
        default:
            return UIColor.green
        }
    }
}
