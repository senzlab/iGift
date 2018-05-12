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
            return UIImage(named: imageNameForTheCell(indexpathNumber: indexpathNumber))!
        case 1:
            return UIImage(named: imageNameForTheCell(indexpathNumber: indexpathNumber))!
        case 2:
            return UIImage(named: imageNameForTheCell(indexpathNumber: indexpathNumber))!
        case 3:
            return UIImage(named: imageNameForTheCell(indexpathNumber: indexpathNumber))!
        case 4:
            return UIImage(named: imageNameForTheCell(indexpathNumber: indexpathNumber))!
        case 5:
            return UIImage(named: imageNameForTheCell(indexpathNumber: indexpathNumber))!
        case 6:
            return UIImage(named: imageNameForTheCell(indexpathNumber: indexpathNumber))!
        case 7:
            return UIImage(named: imageNameForTheCell(indexpathNumber: indexpathNumber))!
        case 8:
            return UIImage(named: imageNameForTheCell(indexpathNumber: indexpathNumber))!
        case 9:
            return UIImage(named: imageNameForTheCell(indexpathNumber: indexpathNumber))!
        case 10:
            return UIImage(named: imageNameForTheCell(indexpathNumber: indexpathNumber))!
        case 11:
            return UIImage(named: imageNameForTheCell(indexpathNumber: indexpathNumber))!
        default:
            return UIImage(named: imageNameForTheCell(indexpathNumber: 0))!
        }
    }
    
    func imageNameForTheCell(indexpathNumber: Int) -> String {
        switch indexpathNumber {
        case 0:
            return "sticker_1"
        case 1:
            return "sticker_2"
        case 2:
            return "sticker_3"
        case 3:
            return "sticker_4"
        case 4:
            return "sticker_5"
        case 5:
            return "sticker_6"
        case 6:
            return "sticker_7"
        case 7:
            return "sticker_8"
        case 8:
            return "sticker_9"
        case 9:
            return "sticker_10"
        case 10:
            return "sticker_11"
        case 11:
            return "sticker_12"
        default:
            return "sticker_1"
        }
    }
}
