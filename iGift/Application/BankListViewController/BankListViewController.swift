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
        self.title = "Select Bank"
    }

    func loadBanks() {
        dataArray = [
            Bank(code: "7010", name: "Bank of Ceylon"),
            Bank(code: "7038", name: "Standard Chartered Bank"),
            Bank(code: "7047", name: "Citi Bank"),
            Bank(code: "7056", name: "Commercial Bank"),
            Bank(code: "7074", name: "Habib Bank"),
            Bank(code: "7083", name: "HNB - Hatton National Bank"),
            Bank(code: "7302", name: "HSBC - Hongkong Shanghai Bank"),
            Bank(code: "7108", name: "Indea Bank"),
            Bank(code: "7384", name: "ICICI Bank Ltd"),
            Bank(code: "7117", name: "Indian Overseas Bank"),
            Bank(code: "7135", name: "Peoples Bank"),
            Bank(code: "7144", name: "State Bank of India"),
            Bank(code: "7162", name: "NTB - Nations Trust Bank"),
            Bank(code: "7205", name: "Deutsche Bank"),
            Bank(code: "7214", name: "NDB - National Development Bank"),
            Bank(code: "7269", name: "MCB Bank"),
            Bank(code: "7278", name: "Sampath Bank"),
            Bank(code: "7287", name: "Seylan Bank"),
            Bank(code: "7296", name: "Public Bank"),
            Bank(code: "7302", name: "Union Bank of Colombo"),
            Bank(code: "7311", name: "Pan Asia Banking Corporation"),
            Bank(code: "7384", name: "ICICI Bank"),
            Bank(code: "7454", name: "DFCC Bank"),
            Bank(code: "7463", name: "Amana Bank"),
            Bank(code: "7472", name: "Axis Bank"),
            Bank(code: "7481", name: "Cargills Bank"),
            Bank(code: "7719", name: "NSB - National Savings Bank"),
            Bank(code: "7728", name: "SDB - Sanasa Development Bank"),
            Bank(code: "7737", name: "HDFC Bank"),
            Bank(code: "7746", name: "CDB - Citizen Development Business Finance"),
            Bank(code: "7755", name: "RDB - Regional Development Bank"),
            Bank(code: "7764", name: "State Mortgage & Investment Bank"),
            Bank(code: "7773", name: "LB Finance"),
            Bank(code: "7782", name: "Senkadagala Finance"),
            Bank(code: "7807", name: "Commercial Leasing and Finance"),
            Bank(code: "7816", name: "Vallibel Finance"),
            Bank(code: "7825", name: "Central Finance"),
            Bank(code: "7834", name: "Kanrich Finance"),
            Bank(code: "7852", name: "Alliance Finance Company"),
            Bank(code: "7861", name: "LOLC Finance"),
            Bank(code: "7870", name: "Commercial Credit & Finance"),
            Bank(code: "7898", name: "Merchant Bank of Sri Lanka & Finance"),
            Bank(code: "7904", name: "HNB Grameen Finance Limited"),
            Bank(code: "7913", name: "Mercantile Investment and Finance"),
            Bank(code: "7922", name: "People's Leasing & Finance"),
            Bank(code: "8004", name: "Central Bank of Sri Lanka"),
            Bank(code: "6990", name: "Lanka Pay Test")
        ]
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
        
        var bank:Bank?
        if filteredArray.count > 0 {
            bank = filteredArray[indexPath.row]
        }
        else {
            bank = dataArray[indexPath.row]
        }
        
        let redeemViewController = RedeemViewController(nibName: "RedeemViewController", bundle: nil)
        redeemViewController.iGift = iGift
        redeemViewController.bank = bank
        self.navigationController?.pushViewController(redeemViewController, animated: false)
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
