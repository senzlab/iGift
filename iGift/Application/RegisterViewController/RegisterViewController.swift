//
//  RegisterViewController.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/11/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import Foundation
import UIKit
import Foundation

// Class that load all view controllers on the main thread
class RegisterViewController : KeyboardScrollableViewController {

    @IBOutlet weak var txtFieldUsername: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var txtFieldConfirmPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }

    func setupUi() {
        self.title = "Register"
        self.setupStylesForTextFields()
    }

    func setupStylesForTextFields(){
        UITextField.applyStyle(txtField: self.txtFieldUsername)
        UITextField.applyStyle(txtField: self.txtFieldPassword)
        UITextField.applyStyle(txtField: self.txtFieldConfirmPassword)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupStylesForTextFields()
    }

    @IBAction func onRegisterClicked(_ sender: Any) {
        // gengerate key pair
        // do register
        CryptoUtil.instance.initKeys()
        doReg()
    }
    
    func doReg() {
        // todo validate input fields
        
        // ui fields
        let zAddress = txtFieldUsername.text
        let password = txtFieldPassword.text
        let confirmPassword = txtFieldConfirmPassword.text
        
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
            
            self.loadView("SecurityQuestionsViewController")
        }
        task.resume()
    }

}
