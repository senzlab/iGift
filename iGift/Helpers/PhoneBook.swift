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

    // Singleton
    static let sharedInstance = PhoneBook()
    private init() {}

    // MARK: Instance Variables
    let contactStore = CNContactStore()

    // MARK: Instance Methods
    func getContacts() -> [PhoneContact] {
        // PLEASE READ - MAKE SURE TO REQUEST PERMISSION FIRST, OTHERWISE APP WILL

        // Declare which data you want to read
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactGivenNameKey,
            CNContactFamilyNameKey] as [Any]

        // Fetch all records
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }

        // Declare return array
        var results: [PhoneContact] = []

        // Filter results into return array
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

            do {

                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])

                // Map data to POJO
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
