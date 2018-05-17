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

    override func viewDidLoad() {
        super.viewDidLoad()
         self.setupUi()
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
        return NUMBER_OF_ROWS
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

        // SetupUI and return cell for each row
        switch indexPath.row {
        case 0:
            cell?.lblName?.text = "Eranga"
            cell?.lblMessage?.text = "He thinks he is Lamda!"
            break
        default:
            print("NO AVAILABLE CELL FOR INDEX - \(indexPath.row)!!")
        }

        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(HEIGHT_OF_ROW)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let designIGiftViewController = DesignIGiftViewController(nibName: "DesignIGiftViewController", bundle: nil)
        self.navigationController?.pushViewController(designIGiftViewController, animated: true)
    }

}
