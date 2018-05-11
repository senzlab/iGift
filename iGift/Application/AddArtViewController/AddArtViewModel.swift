//
//  AddArtViewModel.swift
//  iGift
//
//  Created by AnujAroshA on 5/11/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class AddArtViewModel: NSObject {

    func imageForTheCell(indexpathNumber: Int) -> UIImage {
        switch indexpathNumber {
        case 0:
            return UIImage(named: "sticker_1")!
        case 1:
            return UIImage(named: "sticker_2")!
        case 2:
            return UIImage(named: "sticker_3")!
        case 3:
            return UIImage(named: "sticker_4")!
        case 4:
            return UIImage(named: "sticker_5")!
        case 5:
            return UIImage(named: "sticker_6")!
        case 6:
            return UIImage(named: "sticker_7")!
        case 7:
            return UIImage(named: "sticker_8")!
        case 8:
            return UIImage(named: "sticker_9")!
        case 9:
            return UIImage(named: "sticker_10")!
        case 10:
            return UIImage(named: "sticker_11")!
        case 11:
            return UIImage(named: "sticker_12")!
        default:
            return UIImage(named: "sticker_1")!
        }
    }
}
