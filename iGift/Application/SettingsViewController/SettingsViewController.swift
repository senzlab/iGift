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
            
            let accountNumber:String? = PreferenceUtil.instance.get(key: PreferenceUtil.ACCOUNT)
            var labelTitle:String = ""
            
            if accountNumber == nil {
                labelTitle = "Account"
            }
            else {
                labelTitle = "Account \(accountNumber ?? "")"
            }
            
            cell?.lblTitle?.text = labelTitle
            if(PreferenceUtil.instance.get(key: PreferenceUtil.ACCOUNT_STATUS) == "PENDING") {
                cell?.btnSetting?.setTitle("VERIFY", for: UIControlState.normal)
            } else if(PreferenceUtil.instance.get(key: PreferenceUtil.ACCOUNT_STATUS) == "VERIFIED") {
                cell?.btnSetting?.setTitle("CHANGE", for: UIControlState.normal)
            } else {
                cell?.btnSetting?.setTitle("ADD", for: UIControlState.normal)
            }
            break
        case 1:
            
            let phoneNumber:String? = PreferenceUtil.instance.get(key: PreferenceUtil.PHONE_NUMBER)
            var labelTitle:String = ""
            
            if phoneNumber == nil {
                labelTitle = "Phone no"
            }
            else {
                labelTitle = "Phone no \(phoneNumber ?? "")"
            }
            
            cell?.lblTitle?.text = labelTitle
            cell?.btnSetting?.isHidden = true
            break
        case 2:
            cell?.lblTitle?.text = "Password"
            cell?.btnForgot?.setTitle("FORGOT", for: UIControlState.normal)
            cell?.btnSetting?.setTitle("CHANGE", for: UIControlState.normal)
            cell?.btnForgot.isHidden = false
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
        cell?.btnForgot?.tag = indexPath.row
        
        cell?.btnSetting?.addTarget(self,action:#selector(buttonClicked),
                                    for:.touchUpInside)
        cell?.btnForgot?.addTarget(self,action:#selector(firstButtonClicked),
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
            if(PreferenceUtil.instance.get(key: PreferenceUtil.ACCOUNT_STATUS) == "PENDING") {
                self.loadView("ConfirmAccountViewController")
            } else {
                self.loadView("AddAccountInfoViewController")
            }
        break
        case 1:
            print("Case 1")
            // Change User Btn
        break
        case 2:
            print("Case 2")
            // Change Password Btn
            self.loadView("ChangePasswordViewController")
        break
        case 3:
            print("Case 3")
            // View Terms Btn
            self.loadView("TermsOfUseViewController")
        break
        case 4:
            print("Case 4")
            // View About Btn
            break
        default:
            print("UnIdentified Button Clicked")
        }
    }
    
    @objc func firstButtonClicked(_ sender: CustomButton) {
        switch sender.tag {
        case 0:
            break
        case 1:
            print("Case 1")
            break
        case 2:
            let view = SecurityQuestionsViewController(nibName: "SecurityQuestionsViewController", bundle: nil)
            self.navigationController?.pushViewController(view, animated: false)
            break
        case 3:
            print("Case 3")
            break
        case 4:
            print("Case 4")
            break
        default:
            print("UnIdentified Button Clicked")
        }
    }
}
