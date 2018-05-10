//
//  SettingsViewController.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/8/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController : BaseViewController, UITableViewDelegate, UITableViewDataSource {

    let NUMBER_OF_ROWS = 4
    let HEIGHT_OF_ROW = 85

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }

    func setupUi() {
        self.setNavBarHidden(false)
        self.title = "Settings"
    }



    // --- Start of Table View Logic ---
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NUMBER_OF_ROWS
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Try to find reusable cell
        var cell = tableView.dequeueReusableCell(withIdentifier: "CustomSettingCell") as? CustomSettingCell

        // If not available instantiate new custom cell
        if (cell == nil) {
            var nibArray = NSArray()
            nibArray = Bundle.main.loadNibNamed("CustomSettingCell", owner: self, options: nil)! as NSArray
            cell = nibArray.object(at: 0) as? CustomSettingCell
        }

        // SetupUI and return cell for each row
        switch indexPath.row {
        case 0:
            cell?.rowTitleLbl?.text = "Account"
            cell?.rowSettingBtn?.setTitle("ADD", for: UIControlState.normal)
            break
        case 1:
            cell?.rowTitleLbl?.text = "UserName - "
            cell?.rowSettingBtn?.setTitle("CHANGE", for: UIControlState.normal)
            break
        case 2:
            cell?.rowTitleLbl?.text = "Password"
            cell?.rowSettingBtn?.setTitle("CHANGE", for: UIControlState.normal)
            break
        case 3:
            cell?.rowTitleLbl?.text = "Terms of use"
            cell?.rowSettingBtn?.setTitle("VIEW", for: UIControlState.normal)
            break
        case 4:
            cell?.rowTitleLbl?.text = "About iGift"
            cell?.rowSettingBtn?.setTitle("VIEW", for: UIControlState.normal)
            break
        default:
             print("NO AVAILABLE CELL FOR INDEX - \(indexPath.row)!!")
        }

        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(HEIGHT_OF_ROW)
    }
    // --- End of Table View Logic ---

}
