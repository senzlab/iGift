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

class PhoneBookViewController : BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {

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
                self.goBack(animated: true)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = dataArray[indexPath.row]
        addContact(contact: contact)
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
            
        }else{
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
            ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "This user already added in your iGift contact list")
        } else {
            let alert = UIAlertController(title: "Confirm", message: "Would like to send iGift request to " + contact.name + "?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                SenzProgressView.shared.showProgressView((self.navigationController?.view)!)
                DispatchQueue.global(qos: .userInitiated).async {
                    let z = Httpz.instance.pushSenz(senz: SenzUtil.instance.connectSenz(to: phone))
                    // todo validate z
                    if (z == nil) {
                        DispatchQueue.main.async {
                            SenzProgressView.shared.hideProgressView()
                            ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Fail to send request")
                        }
                    } else {
                        // save user
                        let senzUser = User(id: 1)
                        senzUser.zid = phone
                        senzUser.phone = phone
                        senzUser.isActive = false
                        SenzDb.instance.createUser(user: senzUser)
                        
                        // exit
                        DispatchQueue.main.async {
                            SenzProgressView.shared.hideProgressView()
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                // do nothing
            }))
            
            present(alert, animated: true, completion: nil)
        }
    }
}
