//
//  User.swift
//  iGift
//
//  Created by eranga on 5/9/18.
//  Copyright © 2018 eranga. All rights reserved.
//

import Foundation

class User {
    let id: Int64
    var zid: String = ""
    var phone: String = ""
    var isActive: Bool = false
    
    init(id: Int64) {
        self.id = id
    }
}
