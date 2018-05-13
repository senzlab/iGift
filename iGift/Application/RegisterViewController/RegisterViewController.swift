//
//  RegisterViewController.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/11/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

// Class that load all view controllers on the main thread
class RegisterViewController : BaseViewController {
    @IBOutlet weak var txtFieldUsername: UITextField!

    @IBOutlet weak var txtFieldPassword: UITextField!

    @IBOutlet weak var txtFieldConfirmPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }

    func setupUi() {
        self.setNavBarHidden(false)
        self.title = "Register"
        UITextField.applyStyle(txtField: self.txtFieldUsername)
        UITextField.applyStyle(txtField: self.txtFieldPassword)
        UITextField.applyStyle(txtField: self.txtFieldConfirmPassword)
    }

    @IBAction func onRegisterClicked(_ sender: Any) {
        self.loadView("HomeViewController")
        
        initIgift()
        // todo validate input fields
        
        // do register
        doReg()
    }
    
    func initIgift() {
        // gengerate key pair
        CryptoUtil.instance.initKeys()
    }
    
    func doReg() {
        // zaddress
        let zAddress = txtFieldUsername.text
        
        // data
        let uid = SenzUtil.instance.uid(zAddress: zAddress!)
        let regSenz = SenzUtil.instance.regSenz(uid: uid, zAddress: zAddress!)
        let data = [
            "uid": uid,
            "msg": regSenz
        ]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: data) else {
            print("error decoding json")
            return
        }
        let jsonStr = String(data: jsonData, encoding: String.Encoding.utf8)?
            .replacingOccurrences(of: "\\", with: "")

        // request
        let url = URL(string: "http://10.2.2.9:7171/uzers")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonStr?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // check for errors
            guard let data = data, error == nil else {
                print("error request")
                return
            }
            
            // status should be 200
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                // registration fail
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                return
            }
            
            // registration done
//            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.WritingOptions(rawValue: 0))
//            if let responseJSON = responseJSON as? [String: Any] {
//                print(responseJSON)
//            }
            
            // todo save zaddress, password
        }
        task.resume()
    }

}
