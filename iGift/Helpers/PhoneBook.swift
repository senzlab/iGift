//
//  Utility.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/10/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import Foundation
import ContactsUI
import PhoneNumberKit

class PhoneBook {
    
    static let instance = PhoneBook()

    let contactStore = CNContactStore()
    let phoneNumberKit = PhoneNumberKit()
    
    lazy var contacts: [SenzContact] = {
        var results: [SenzContact] = []
        
        // data we need
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactThumbnailImageDataKey] as [Any]
        
        // get contacts
        let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
        do {
            try contactStore.enumerateContacts(with: request) { (contact, stop) in
                for num in contact.phoneNumbers {
                    let phn = self.internationalize(phone: num.value.stringValue)
                    if phn != nil {
                        results.append(SenzContact(name: contact.givenName, phone: phn!, thumbnail: contact.thumbnailImageData))
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return results
    }()

    func getContacts() -> [SenzContact] {
        return contacts
    }
    
    func getContact(phone: String) -> SenzContact? {
        for contact in self.contacts {
            let phn = contact.phone.replacingOccurrences(of: " ", with: "")
            if (!phn.isEmpty && phn == phone) {
                return contact
            }
        }
        
        return nil
    }
    
    func getAllContacts() -> [SenzContact] {
        var contacts = [SenzContact]()
        
        // data we need
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactThumbnailImageDataKey] as [Any]
        
        // get contacts
        let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
        do {
            try contactStore.enumerateContacts(with: request) { (contact, stop) in
                for num in contact.phoneNumbers {
                    let phn = self.internationalize(phone: num.value.stringValue)
                    if phn != nil {
                        contacts.append(SenzContact(name: contact.givenName, phone: phn!, thumbnail: contact.thumbnailImageData))
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }

        return contacts
    }
    
    func internationalize(phone: String) -> String? {
        do {
            return phoneNumberKit.format(try phoneNumberKit.parse(phone), toType: .international)
        } catch {
            return nil
        }
    }

    func checkPermission() -> CNAuthorizationStatus {
        return CNContactStore.authorizationStatus(for: .contacts)
    }

    func requestAccess(_ resolve: @escaping ((Bool) -> Void)) {
        contactStore.requestAccess(for: .contacts){succeeded, err in
            guard err == nil && succeeded else{
                    resolve(false)
                    return;
            }
            resolve(true)
        }
    }
}
