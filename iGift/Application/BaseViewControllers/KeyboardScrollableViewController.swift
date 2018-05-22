//
//  KeyboardScrollableViewController.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/13/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class KeyboardScrollableViewController : BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView?
    var activeField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerForKeyboardNotifications()
        self.hideKeyBoardOnLostFocus()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.deregisterFromKeyboardNotifications()
        activeField = nil
    }

    func registerForKeyboardNotifications(){
        // Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func deregisterFromKeyboardNotifications(){
        // Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    @objc func keyboardWasShown(notification: NSNotification){
        // Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView?.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)

        self.scrollView?.contentInset = contentInsets
        self.scrollView?.scrollIndicatorInsets = contentInsets

        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height + 30
        if let activeField = self.activeField {
            if (!aRect.contains(activeField.frame.origin)){
                self.scrollView?.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }

    @objc func keyboardWillBeHidden(notification: NSNotification){
        // Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView?.contentInset = contentInsets
        self.scrollView?.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView?.isScrollEnabled = false
    }

    func textFieldDidBeginEditing(_ textField: UITextField){
        activeField = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }
}

