//
//  ApplicationViewController.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/11/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

// Class that load all view controllers on the main thread
class ApplicationViewController : UIViewController {


    func loadAccountView() {
        loadView("AddAccountViewController")
    }

    func loadView(_ name: String) {
        let viewController = getNewInstance(name)
        if let controller = viewController {
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(controller, animated: true)
            }
        } else {
            print("Trying to load an unregistered view controller. Please look into ApplicationViewController class to register view controller")
        }
    }

    func goBack(animated: Bool) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: animated)
        }
    }


    func getNewInstance(_ name: String) -> UIViewController? {
        switch name {
        case "AddAccountViewController":
            return AddAccountViewController(nibName: "AddAccountViewController", bundle: nil)
        case "SettingsViewController":
            return SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        case "RegisterViewController":
            return RegisterViewController(nibName: "RegisterViewController", bundle: nil)
        case "PhoneBookViewController":
            return PhoneBookViewController(nibName: "PhoneBookViewController", bundle: nil)
        case "ContactsViewController":
            return ContactsViewController(nibName: "ContactsViewController", bundle: nil)
        case "HomeViewController":
            return HomeViewController(nibName: "HomeViewController", bundle: nil)
        case "SecurityAnswersViewController":
            return SecurityAnswersViewController(nibName: "SecurityAnswersViewController", bundle: nil)
        case "SecurityQuestionsViewController":
            return SecurityQuestionsViewController(nibName: "SecurityQuestionsViewController", bundle: nil)
        case "IGiftsViewController":
            return IGiftsReceivedViewController(nibName: "IGiftsReceivedViewController", bundle: nil)
//            return IGiftsViewController(nibName: "IGiftsViewController", bundle: nil)
        default:
            return nil
        }
    }
}
