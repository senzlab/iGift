//
//  DesignIGiftViewController.swift
//  iGift
//
//  Created by AnujAroshA on 5/9/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class DesignIGiftViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var sendGiftButton: UIButton!
    @IBOutlet weak var currencyValueTextField: UITextField!
    @IBOutlet weak var giftMsgTextView: UITextView!
    
    var userTryingToGiveCurrencyValue: Bool = false
    var keyboardHeight: CGFloat!
    
    //    MARK: UIViewController related
    override func viewDidLoad() {
        super.viewDidLoad()
        print((#file as NSString).lastPathComponent)
        self.setupUi()
        
        currencyValueTextField.delegate = self
        
//        Notify keyboard visibility to the view
        NotificationCenter.default.addObserver(self, selector: #selector(DesignIGiftViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DesignIGiftViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
//        Added a tap gesture in order to dismiss the keyboard once it is visible since we haven't given Done button in the keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //    MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == currencyValueTextField {
            userTryingToGiveCurrencyValue = true
            giftMsgTextView.isUserInteractionEnabled = false;
        }
    }
    
    //    MARK: Observer selectors
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if userTryingToGiveCurrencyValue {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    
                    if keyboardHeight == nil {
                        keyboardHeight = keyboardSize.height
                    }
                    
                    self.view.frame.origin.y -= keyboardHeight
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if userTryingToGiveCurrencyValue {
            if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
                if self.view.frame.origin.y != 0 {
                    self.view.frame.origin.y += keyboardHeight
                }
            }
        }
    }
    
    //    MARK: Gesture selectors
    @objc func dismissKeyboard() {
        view.endEditing(true)
        userTryingToGiveCurrencyValue = false
        giftMsgTextView.isUserInteractionEnabled = true;
    }
    
    //    MARK: Action functions
    @IBAction func sendGiftAction(_ sender: UIButton) {
    }
    
    @IBAction func cameraAction(_ sender: UIButton) {
        
    }
    
    @IBAction func addArtAction(_ sender: UIButton) {
        
    }
    
    @IBAction func changeBgColorAction(_ sender: UIButton) {
        
    }
    
    //    MARK: Supportive functions
    func setupUi() {
        self.setNavBarHidden(false)
        self.title = "Design iGifts"
        
//        Creating a circular button
        sendGiftButton.layer.cornerRadius = 0.5 * sendGiftButton.bounds.size.width;
        
        giftMsgTextView.placeholder = "Write your message here"
    }
}
