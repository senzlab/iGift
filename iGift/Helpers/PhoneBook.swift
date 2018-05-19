//
//  Utility.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/10/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import Foundation
import ContactsUI

class PhoneBook {
    
    static let instance = PhoneBook()

    let contactStore = CNContactStore()
    
    lazy var contacts: [PhoneContact] = {
        // data we need
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactGivenNameKey,
            CNContactFamilyNameKey] as [Any]
        
        // fetch all records
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        
        var results: [PhoneContact] = []
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                let tranformedResults = containerResults.map({ (contact:CNContact) -> PhoneContact in
                    return PhoneContact(contact: contact)
                })
                results.append(contentsOf: tranformedResults)
            } catch {
                print("Error fetching containers")
            }
        }
        
        return results
    }()

    func getContacts() -> [PhoneContact] {
        return contacts
    }
    
    func getContact(phone: String) -> PhoneContact? {
        for contact in self.contacts {
            if (!contact.phoneNumber.isEmpty) {
                for p in contact.phoneNumber {
                    if (p == phone) {
                        return contact
                    }
                }
            }
        }
        
        return nil
    }
    
    func getAllContacts() -> [PhoneContact] {
        // PLEASE READ - MAKE SURE TO REQUEST PERMISSION FIRST, OTHERWISE APP WILL

        // data we need
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactGivenNameKey,
            CNContactFamilyNameKey] as [Any]

        // fetch all records
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }

        var results: [PhoneContact] = []
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                let tranformedResults = containerResults.map({ (contact:CNContact) -> PhoneContact in
                    return PhoneContact(contact: contact)
                })
                results.append(contentsOf: tranformedResults)
            } catch {
                print("Error fetching containers")
            }
        }

        return results
    }

    func checkPermission() -> CNAuthorizationStatus{
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
