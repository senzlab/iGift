//
//  PhoneBookViewController.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/9/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import Foundation
import UIKit
import Contacts
import ContactsUI
import StoreKit
import MessageUI

class PhoneBookViewController : BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, MFMessageComposeViewControllerDelegate, AlertViewControllerDelegate {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var searchPlaceHolder: UIView!

    var dataArray = [SenzContact]()
    var filteredArray = [SenzContact]()
    var shouldShowSearchResults = false
    var searchBar: CustomSearchBar!
    let HEIGHT_OF_ROW = 60

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
        
        tblView.addSubview(self.refreshControl)
        
        self.loadContacts()
    }

    func setupUi() {
        self.configureCustomSearchController()
        self.title = "Phone Book"
    }

    func loadContacts() {
        PhoneBook.instance.requestAccess({value in
            if value {
                self.dataArray = PhoneBook.instance.getContacts()
                self.reloadTable()
            } else {
                print("PhoneBook Permission Denied by user!!")
                self.goBack(animated: false)
            }
        })
    }

    func reloadTable() {
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredArray.count
        }
        else {
            return dataArray.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Try to find reusable cell
        var cell = tableView.dequeueReusableCell(withIdentifier: "CustomPhoneBookCell") as? CustomPhoneBookCell

        // If not available instantiate new custom cell
        if (cell == nil) {
            var nibArray = NSArray()
            nibArray = Bundle.main.loadNibNamed("CustomPhoneBookCell", owner: self, options: nil)! as NSArray
            cell = nibArray.object(at: 0) as? CustomPhoneBookCell
        }

        // Select Array to use to load table
        let tableArray : [SenzContact] = shouldShowSearchResults ? self.filteredArray : self.dataArray

        // Setup Cells in table
        cell?.lblName?.text = tableArray[indexPath.row].name
        cell?.lblPhoneNo?.text = tableArray[indexPath.row].phone

        cell?.selectionStyle = .none
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(HEIGHT_OF_ROW)
    }
    
    //    MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var contact:SenzContact?
        if filteredArray.count > 0 {
            contact = filteredArray[indexPath.row]
        }
        else {
            contact = dataArray[indexPath.row]
        }

        addContact(contact: contact!)
    }
    
    func configureCustomSearchController() {
        self.searchBar = CustomSearchBar(searchBarFrame: CGRect(x: 0.0,y: 0.0, width: tblView.frame.size.width, height: 56.0), searchBarFont: UIFont(name: Constants.MAIN_FONT_FAMILY.rawValue, size: 22.0)!, searchBarTextColor: UIColor.fromHex(HexColors.PRIMARY_COLOR.rawValue), searchBarTintColor: UIColor.fromHex(HexColors.WHITE_COLOR.rawValue), placeholderText: "Search Contacts")
        self.searchBar.delegate = self
        self.searchPlaceHolder.addSubview(searchBar)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        filteredArray.removeAll()
        filteredArray = dataArray
        self.reloadTable()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        self.searchBar.text = ""
        searchBar.resignFirstResponder()
        self.reloadTable()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            self.reloadTable()
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            filteredArray.removeAll()
            filteredArray = dataArray
        } else{
            filteredArray = dataArray.filter({ (phoneRecord) -> Bool in
                return phoneRecord.name.lowercased().range(of:searchText.lowercased()) != nil
            })
        }
        
        self.reloadTable()
    }
    
    func addContact(contact: SenzContact) {
        let phone = contact.phone.replacingOccurrences(of: " ", with: "")
        if (SenzDb.instance.getUser(phn: phone) != nil) {
            // user exists
            ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "This user already added in your igift contact list")
        } else {
            // ask to send request
            view.endEditing(true)
            askSendRequest(contact: contact, phone: phone)
        }
    }
    
    func askSendRequest(contact: SenzContact, phone: String) {
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to add " + contact.name + " as an igift contact?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            // send request
            SenzProgressView.shared.showProgressView((self.navigationController?.view)!)
            DispatchQueue.global(qos: .userInitiated).async {
                let uid = SenzUtil.instance.uid(zAddress: phone)
                let senz = SenzUtil.instance.connectSenz(uid: uid, to: phone)
                
                // post to contractz
                let dict = ["Uid": uid, "Msg": senz]
                Httpz.instance.doPost(param: dict, onComplete: {(senzes: [Senz]) -> Void in
                    if (senzes.count > 0 && senzes.first!.attr["#status"] == "200") {
                        // request created
                        // save user
                        let senzUser = User(id: 1)
                        senzUser.zid = phone
                        senzUser.phone = phone
                        senzUser.isRequester = true
                        senzUser.isActive = false
                        _ = SenzDb.instance.createUser(user: senzUser)
                        
                        // exit
                        DispatchQueue.main.async {
                            SenzProgressView.shared.hideProgressView()
                            let viewContUtil = ViewControllerUtil()
                            viewContUtil.delegate = self
                            viewContUtil.showAlertWithSingleActions(alertTitle: "Notice", alertMessage: "Contact request has been sent", viewController: self)
                        }
                    } else if(senzes.count > 0 && senzes.first!.attr["#status"] == "404") {
                        // this means user does not exists
                        // ask for sms request
                        DispatchQueue.main.async {
                            SenzProgressView.shared.hideProgressView()
                            self.askSendSms(contact: contact, phone: phone)
                        }
                    } else {
                        // fail
                        DispatchQueue.main.async {
                            SenzProgressView.shared.hideProgressView()
                            ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Fail to send request")
                        }
                    }
                })
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            // do nothing
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func askSendSms(contact: SenzContact, phone: String) {
        let message = contact.name + " is not using sampath igift app, would you like to send invitation via SMS?"
        let alert = UIAlertController(title: "Confirm", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            
            if !MFMessageComposeViewController.canSendText() {
                ViewControllerUtil.showAlert(alertTitle: "Notice", alertMessage: "SMS services are not available")
            } else {
                let composeVC = MFMessageComposeViewController()
                composeVC.messageComposeDelegate = self
                
                // Configure the fields of the interface.
                composeVC.recipients = [phone]
                composeVC.body = "Remembering every moment with Sampath igift. Please, download Sampath igift from App Store to receive my igift. Experience the new wave of gifting"
                
                // Present the view controller modally.
                self.present(composeVC, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            // do nothing
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    //    MARK: MFMessageComposeViewControllerDelegate
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        // Check the result or perform other tasks.
        // Dismiss the message compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
    //    MARK : Pull to refresh
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.orange
        
        return refreshControl
    }()

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        // refresh phone book
        PhoneBook.instance.refresh()

        self.dataArray = PhoneBook.instance.getContacts()
        self.reloadTable()
        refreshControl.endRefreshing()
    }
    
    //    MARK: AlertViewControllerDelegate
    func executeTaskForAction(actionTitle: String) {
        if actionTitle == "OK" {
            DispatchQueue.main.async {
                // back to home
                self.loadView("HomeViewController")
            }
        }
    }
}
