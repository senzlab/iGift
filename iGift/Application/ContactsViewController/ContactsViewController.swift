//
//  ContactsViewController.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/8/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import Foundation
import UIKit
import Contacts

class ContactsViewController : BaseViewController, UITableViewDelegate, UITableViewDataSource {

    let NUMBER_OF_ROWS = 1
    let HEIGHT_OF_ROW = 85

    var dataArray: [User]!
    var forNewIgift: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
        dataArray = SenzDb.instance.getUsers(active: forNewIgift)
    }

    func setupUi() {
        if (forNewIgift) {
            self.title = "Choose contact"
        } else {
            self.title = "Contacts"
        }
    }

    @IBAction func onAddContactBtnClicked(_ sender: Any) {
        let permission = PhoneBook.instance.checkPermission()
        if (permission == CNAuthorizationStatus.denied) {
            UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)
        } else {
            self.loadView("PhoneBookViewController")
        }
    }

    // --- Start of Table View Logic ---
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Try to find reusable cell
        var cell = tableView.dequeueReusableCell(withIdentifier: "CustomContactCell") as? CustomContactCell

        // If not available instantiate new custom cell
        if (cell == nil) {
            var nibArray = NSArray()
            nibArray = Bundle.main.loadNibNamed("CustomContactCell", owner: self, options: nil)! as NSArray
            cell = nibArray.object(at: 0) as? CustomContactCell
        }

        let data = dataArray[indexPath.row]
        
        // SetupUI and return cell for each row
        
        let senzContact = PhoneBook.instance.getContact(phone: data.phone)
        cell?.lblName?.text = senzContact?.name
        cell?.lblMessage?.text = senzContact?.phone
        if (!data.isActive) {
            if data.isRequester {
                cell?.lblUserStatus?.setTitle("Sent request", for: .normal)
            } else {
                cell?.lblUserStatus?.setTitle("New request", for: .normal)
            }
        } else {
            cell?.lblUserStatus?.isHidden = true
        }
        cell?.selectionStyle = .none
        
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(HEIGHT_OF_ROW)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = dataArray[indexPath.row]
        if user.isActive {
            // goto new igift
            let designIGiftViewController = DesignIGiftViewController(nibName: "DesignIGiftViewController", bundle: nil)
            designIGiftViewController.user = user
            self.navigationController?.pushViewController(designIGiftViewController, animated: true)
        } else {
            // send request
            if !user.isRequester {
                // ask to confirm request
                confirmRequest(user: user)
            }
        }
    }
    
    func confirmRequest(user: User) {
        let alert = UIAlertController(title: "Confirm", message: "Would like to accept the request from " + user.phone + "?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            // send request
            let senz = SenzUtil.instance.connectSenz(to: user.phone)
            let z = Httpz.instance.pushSenz(senz: senz)
            if z == nil {
                // reg fail
                ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Fail to confirm request")
            } else {
                // reg done
                SenzDb.instance.markAsActive(id: user.zid)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            // do nothing
        }))
        
        present(alert, animated: true, completion: nil)
    }
}
