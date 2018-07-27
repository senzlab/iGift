//
//  HomeViewController.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/8/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import Foundation
import UIKit

enum VersionError: Error {
    case invalidResponse, invalidBundleInfo
}

class HomeViewController : BaseViewController, AlertViewControllerDelegate {
    
    var shouldShowSecAnsSavedMsg:Bool = false
    var updateAlertDisplayes = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
        
        //applicationDidBecomeActive()
        checkForUpdates()
    }
    
    func setupUi() {
        self.setNavBarHidden(true)
        self.title = "Home"
    }

    @IBAction func onContactsBtnClicked(_ sender: Any) {
        let contactsViewController = ContactsViewController(nibName: "ContactsViewController", bundle: nil)
        contactsViewController.forNewIgift = false
        self.navigationController?.pushViewController(contactsViewController, animated: false)
    }

    @IBAction func onSettingsBtnClicked(_ sender: Any) {
        self.loadView("SettingsViewController")
    }

    @IBAction func onSendIGiftsBtnClicked(_ sender: Any) {
        if (PreferenceUtil.instance.get(key: PreferenceUtil.ACCOUNT).isEmpty) {
            // no account
            // verified account
            self.loadView("AddAccountInfoViewController")
        } else {
            // have account
            if (PreferenceUtil.instance.get(key: PreferenceUtil.ACCOUNT_STATUS) == "VERIFIED") {
                // verified account
                if (SenzDb.instance.hasUsers()) {
                    let contactsViewController = ContactsViewController(nibName: "ContactsViewController", bundle: nil)
                    contactsViewController.forNewIgift = true
                    self.navigationController?.pushViewController(contactsViewController, animated: false)
                } else {
                    let noContactViewController = NoContactViewController(nibName: "NoContactViewController", bundle: nil)
                    self.navigationController?.pushViewController(noContactViewController, animated: false)
                }
            }
            else {
                // not verified account
                self.loadView("ConfirmAccountViewController")
            }
        }
    }

    @IBAction func onIGiftsBtnClicked(_ sender: Any) {
        self.loadView("IGiftsViewController")
    }
    
    func checkForUpdates() {
        DispatchQueue.global(qos: .userInitiated).async {
            let uid = SenzUtil.instance.uid(zAddress: PreferenceUtil.instance.get(key: PreferenceUtil.PHONE_NUMBER))
            let senz = SenzUtil.instance.versionSenz(uid: uid)
            
            // post to contractz/check version
            let dict = ["Uid": uid, "Msg": senz]
            Httpz.instance.doPost(param: dict, onComplete: {(senzes: [Senz]) -> Void in
                if (senzes.count > 0) {
                    if let iosv = senzes.first!.attr["#ios"] {
                        // comapre version
                        if let appv = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                            if iosv != appv {
                                // ask for update version
                                DispatchQueue.main.async {
                                    self.updateAlertDisplayes = true
                                    let viewContUtil = ViewControllerUtil()
                                    viewContUtil.delegate = self
                                    viewContUtil.showAlertWithSingleActions(alertTitle: "Update igift", alertMessage: "New version of igift application available on iTuens store. Please update the new version for better usage", viewController: self)
                                }
                            }
                        }
                    }
                }
            })
        }
    }
    
    //    MARK: AlertViewControllerDelegate
    func executeTaskForAction(actionTitle: String) {
        if actionTitle == "OK" {
            self.updateAlertDisplayes = false
            DispatchQueue.main.async {
                if let url = URL(string: "itms://itunes.apple.com/de/app/x-gift/id1389725182?mt=8&uo=4"),
                    UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        }
    }
    
    //    MARK: Supportive functions
    func applicationDidBecomeActive() {
        if !updateAlertDisplayes {
            DispatchQueue.global().async {
                _ = try? self.isUpdateAvailable { (update, error) in
                    if let error = error {
                        print(error)
                    } else if let update = update {
                        print(update)
                        
                        if (update) {
                            DispatchQueue.main.async {
                                self.updateAlertDisplayes = true
                                let viewContUtil = ViewControllerUtil()
                                viewContUtil.delegate = self
                                viewContUtil.showAlertWithSingleActions(alertTitle: "Update igift", alertMessage: "New version of igift application available on iTuens store. Please update the new version for better usage", viewController: self)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func isUpdateAvailable(completion: @escaping (Bool?, Error?) -> Void) throws -> URLSessionDataTask {
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                throw VersionError.invalidBundleInfo
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw VersionError.invalidResponse }
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
                guard let result = (json?["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String else {
                    throw VersionError.invalidResponse
                }
                completion(version != currentVersion, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
        return task
    }
}
