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
    var uid: String
    var user: String
    var timestamp: Int64
    var isMyIgift: Bool
    var isViewed: Bool
    var account: String
    var amount: String
    var blob: String
    var state: String
    
    init(id: Int64,
         uid: String = "",
         user: String = "",
         timestamp: Int64 = 0,
         isMyIgift: Bool = true,
         isViewed: Bool = true,
         account: String = "",
         amount: String = "",
         blob: String = "",
         state: String = "") {

        self.id = id
        self.uid = uid
        self.user = user
        self.timestamp = timestamp
        self.isMyIgift = isMyIgift
        self.isViewed = isViewed
        self.account = account
        self.amount = amount
        self.blob = blob
        self.state = state
    }
}
