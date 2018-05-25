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

class BankListViewController : BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var searchPlaceHolder: UIView!

    var iGift: Igift? = nil
    var dataArray = [Bank]()
    var filteredArray = [Bank]()
    var shouldShowSearchResults = false
    var searchBar: CustomSearchBar!
    let HEIGHT_OF_ROW = 60

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
        self.loadBanks()
    }

    func setupUi() {
        self.configureCustomSearchController()
        self.title = "Phone Book"
    }

    func loadBanks() {
        dataArray = [Bank(code: "001", name: "Com bank"),
                     Bank(code: "002", name: "Sam bank"),
                     Bank(code: "003", name: "ADSL bank"),
                     Bank(code: "004", name: "CAG bank"),
                     Bank(code: "005", name: "For bank"),
                     Bank(code: "006", name: "Net bank"),
                     Bank(code: "007", name: "ASIA bank"),
                     Bank(code: "008", name: "BOC bank")]
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
        var cell = tableView.dequeueReusableCell(withIdentifier: "CustomBankCell") as? CustomBankCell

        // If not available instantiate new custom cell
        if (cell == nil) {
            var nibArray = NSArray()
            nibArray = Bundle.main.loadNibNamed("CustomBankCell", owner: self, options: nil)! as NSArray
            cell = nibArray.object(at: 0) as? CustomBankCell
        }

        // Select Array to use to load table
        let tableArray : [Bank] = shouldShowSearchResults ? self.filteredArray : self.dataArray

        // Setup Cells in table
        cell?.lblName?.text = tableArray[indexPath.row].name
        cell?.lblCode?.text = tableArray[indexPath.row].code

        cell?.selectionStyle = .none
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(HEIGHT_OF_ROW)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bank = dataArray[indexPath.row] 
        let redeemViewController = RedeemViewController(nibName: "RedeemViewController", bundle: nil)
        redeemViewController.iGift = iGift
        redeemViewController.bank = bank
        self.navigationController?.pushViewController(redeemViewController, animated: true)
    }

    func configureCustomSearchController() {
        self.searchBar = CustomSearchBar(searchBarFrame: CGRect(x: 0.0,y: 0.0, width: tblView.frame.size.width, height: 56.0), searchBarFont: UIFont(name: Constants.MAIN_FONT_FAMILY.rawValue, size: 22.0)!, searchBarTextColor: UIColor.fromHex(HexColors.PRIMARY_COLOR.rawValue), searchBarTintColor: UIColor.fromHex(HexColors.WHITE_COLOR.rawValue), placeholderText: "Search Bank")
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
    
    
}
