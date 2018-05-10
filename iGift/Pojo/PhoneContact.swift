//
//  PhoneContact.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/10/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import Foundation
import ContactsUI

class PhoneContact: NSObject {

    var name: String?
    var phoneNumber: [String] = [String]()

    init(contact: CNContact) {
        self.name = contact.givenName + " " + contact.familyName
        for phone in contact.phoneNumbers {
            phoneNumber.append(phone.value.stringValue)
        }
    }
}
