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

class ContactsViewController : BaseViewController, UITableViewDelegate, UITableViewDataSource, AlertViewControllerDelegate {

    let NUMBER_OF_ROWS = 1
    let HEIGHT_OF_ROW = 85

    var dataArray: [User]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.setupUi()
        
        let user = User(id: 1)
        user.phone = "1234445"
        SenzDb.instance.createUser(user: user)
        dataArray = SenzDb.instance.getUsers()
    }

    func setupUi() {
        self.title = "Contacts"
    }

    @IBAction func onAddContactBtnClicked(_ sender: Any) {
        let permission = PhoneBook.sharedInstance.checkPermission()
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
        
        cell?.lblName?.text = data.phone
        cell?.lblMessage?.text = data.phone
        //TODO, set 'New request' and 'New send'
        cell?.lblUserStatus?.setTitle("New request", for: .normal)
    
        cell?.selectionStyle = .none
        
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(HEIGHT_OF_ROW)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewControllerUtil = ViewControllerUtil()
        viewControllerUtil.delegate = self
        viewControllerUtil.showAlertWithTwoActions(alertTitle: "Title", alertMessage: "Message", viewController:self)
    }
    
    //    MARK: AlertViewControllerDelegate
    func executeTaskForAction(actionTitle: String) {
        
        if actionTitle == "OK" {
            let designIGiftViewController = DesignIGiftViewController(nibName: "DesignIGiftViewController", bundle: nil)
            self.navigationController?.pushViewController(designIGiftViewController, animated: true)
        }
        else if actionTitle == "CANCEL" {
            
        } else {}
    }
}
