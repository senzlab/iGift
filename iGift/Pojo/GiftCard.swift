//
//  GiftCard.swift
//  iGift
//
//  Created by AnujAroshA on 5/11/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

final class GiftCard {

    static let shared = GiftCard()
    var capturedImage: UIImage!
    var backgroundColor: UIColor!
    
    private init() {}
}
