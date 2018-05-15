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

    let NUMBER_OF_ROWS = 5
    let HEIGHT_OF_ROW = 85

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }

    func setupUi() {
        self.title = "Settings"
    }

    // MARK: Start of Table View Logic
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

        cell?.btnForgot.isHidden = true
        // SetupUI and return cell for each row
        switch indexPath.row {
        case 0:
            cell?.lblTitle?.text = "Account"
            cell?.btnSetting?.setTitle("ADD", for: UIControlState.normal)
            break
        case 1:
            cell?.lblTitle?.text = "Phone no"
            cell?.btnSetting?.setTitle("CHANGE", for: UIControlState.normal)
            cell?.btnForgot.setTitle("FORGOT", for: UIControlState.normal)
            cell?.btnForgot.isHidden = false
            break
        case 2:
            cell?.lblTitle?.text = "Password"
            cell?.btnSetting?.setTitle("CHANGE", for: UIControlState.normal)
            break
        case 3:
            cell?.lblTitle?.text = "Terms of use"
            cell?.btnSetting?.setTitle("VIEW", for: UIControlState.normal)
            break
        case 4:
            cell?.lblTitle?.text = "About iGift"
            cell?.btnSetting?.setTitle("VIEW", for: UIControlState.normal)
            break
        default:
             print("NO AVAILABLE CELL FOR INDEX - \(indexPath.row)!!")
        }

        // Setup Click Listener
        cell?.btnSetting?.tag = indexPath.row
        cell?.btnSetting?.addTarget(self,action:#selector(buttonClicked),
                                    for:.touchUpInside)

        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(HEIGHT_OF_ROW)
    }

    // MARK: Click Listener
    @objc func buttonClicked(_ sender: CustomButton) {
        switch sender.tag {
        case 0:
            self.loadView("AddAccountInfoViewController")
        break
        case 1:
            // Change User Btn
        break
        case 2:
            // Change Password Btn
        break
        case 3:
            // View Terms Btn
        break
        case 4:
            // View About Btn
            break
        default:
            print("UnIdentified Button Clicked")
        }
    }
}
