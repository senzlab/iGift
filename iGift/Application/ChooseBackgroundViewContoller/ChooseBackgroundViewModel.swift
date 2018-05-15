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
            return UIColor.fromHex(0x2E86C1)
        case 1:
            return UIColor.fromHex(0x000000)
        case 2:
            return UIColor.fromHex(0x78281F)
        case 3:
            return UIColor.fromHex(0x3C3348)
        case 4:
            return UIColor.fromHex(0xa9d063)
        case 5:
            return UIColor.fromHex(0x125688)
        case 6:
            return UIColor.fromHex(0x333333)
        case 7:
            return UIColor.fromHex(0xF88F8C)
        case 8:
            return UIColor.fromHex(0xBB8FCE)
        case 9:
            return UIColor.fromHex(0x008080)
        case 10:
            return UIColor.fromHex(0xF0B27A)
        case 11:
            return UIColor.fromHex(0x5B2C6F)
        default:
            return UIColor.fromHex(0x2E86C1)
        }
    }
}
