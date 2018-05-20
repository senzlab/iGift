//
//  SenzContact.swift
//  iGift
//
//  Created by eranga on 5/19/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import Foundation

class SenzContact {
    var name: String
    var phone: String
    var thumbnail: Data?
    
    init(name: String, phone: String, thumbnail: Data?) {
        self.name = name
        self.phone = phone
        self.thumbnail = thumbnail
    }
}
