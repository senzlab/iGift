//
//  Igift.swift
//  iGift
//
//  Created by eranga on 5/10/18.
//  Copyright © 2018 eranga. All rights reserved.
//

import Foundation

class Igift {
    let id: Int64
    var uid: String = ""
    var user: String = ""
    var timestamp: Int64 = 0
    var isMyIgift: Bool = true
    var isViewed: Bool = true
    var account: String = ""
    var amount: String = ""
    var blob: String = ""
    var state: String = ""
    
    init(id: Int64) {
        self.id = id
    }
}
