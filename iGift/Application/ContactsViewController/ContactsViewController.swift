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

    let HEIGHT_OF_ROW = 85

    var dataArray: [User]!
    var forNewIgift: Bool = false
    
    @IBOutlet weak var contactTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        reloadDataTable()
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

    //    MARK: UITableViewDataSource
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
        let senzContact = PhoneBook.instance.getContact(phone: data.phone)
        cell?.lblName?.text = senzContact?.name
        cell?.lblMessage?.text = senzContact?.phone

        if senzContact == nil {
            cell?.lblName?.text = data.phone
            cell?.lblMessage?.text = data.phone
        } else {
            cell?.lblName?.text = senzContact?.name
            cell?.lblMessage?.text = senzContact?.phone
        }
        
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

    //    MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(HEIGHT_OF_ROW)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = dataArray[indexPath.row]
        if user.isActive {
            if (forNewIgift && PreferenceUtil.instance.get(key: PreferenceUtil.ACCOUNT_STATUS) == "VERIFIED") {
                // goto new igift
                let designIGiftViewController = DesignIGiftViewController(nibName: "DesignIGiftViewController", bundle: nil)
                designIGiftViewController.user = user
                self.navigationController?.pushViewController(designIGiftViewController, animated: false)
            }
        } else {
            // send request
            if !user.isRequester {
                // ask to confirm request
                confirmRequest(user: user)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let user = dataArray[indexPath.row]
            // check user has igifts to reddem
            if (SenzDb.instance.hasIgiftsToRedeem(phone: user.phone)) {
                // show message that user has igifts to redeem
                ViewControllerUtil.showAlert(alertTitle: "Notice", alertMessage: "You have igifts from this contact which not yet redeemed. Please redeem them before removing the contact")
            } else {
                // delete igifts
                // delete user
                _ = SenzDb.instance.deleteUser(id: user.zid)
                _ = SenzDb.instance.deleteIgiftsOfUser(phone: user.phone)
                reloadDataTable()
            }
        }
    }
    
    func confirmRequest(user: User) {
        let alert = UIAlertController(title: "Confirm", message: "Would you like to accept the request from " + user.phone + "?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            // send request
            SenzProgressView.shared.showProgressView((self.navigationController?.view)!)
            DispatchQueue.global(qos: .userInitiated).async {
                let senz = SenzUtil.instance.connectSenz(to: user.phone)
                let z = Httpz.instance.pushSenz(senz: senz)
                if z == nil {
                    // fail
                    DispatchQueue.main.async {
                        SenzProgressView.shared.hideProgressView()
                        ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Fail to confirm request")
                    }
                } else {
                    if (SenzUtil.instance.verifyStatus(z: z!)) {
                        // done, exit from here
                        _ = SenzDb.instance.markAsActive(id: user.zid)
                        DispatchQueue.main.async {
                            SenzProgressView.shared.hideProgressView()
                            self.navigationController?.popViewController(animated: false)
                        }
                        
                        // todo reload list
                    } else {
                        DispatchQueue.main.async {
                            SenzProgressView.shared.hideProgressView()
                            ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Fail to confirm request")
                        }
                    }
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            // do nothing
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    //    MARK : Supportive functions
    func reloadDataTable() {
        dataArray = SenzDb.instance.getUsers(active: forNewIgift)
        
        if dataArray.count == 0 {
            contactTableView.isHidden = true
        }
        else {
            contactTableView.isHidden = false
        }
        
        contactTableView.reloadData()
    }
}
