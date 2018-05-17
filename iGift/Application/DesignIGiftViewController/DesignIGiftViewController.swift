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
    @IBOutlet weak var capturedPhotoImageView: UIImageView!
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var giftModifyView: UIView!
    
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
        
//        Will initiate creating sticker image with pan attribute
        NotificationCenter.default.addObserver(self, selector: #selector(createStickerImage(notification:)), name: .tappedOnArtItem, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if GiftCard.shared.capturedImage != nil {
            capturedPhotoImageView.isHidden = false
            capturedPhotoImageView.image = GiftCard.shared.capturedImage
        }
        else {
            capturedPhotoImageView.isHidden = true
        }
        
        if GiftCard.shared.backgroundColor != nil {
            rootView.backgroundColor = GiftCard.shared.backgroundColor
        }
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
                
                let navPlusStatusBarHeight = navigationBarHeight(viewController: self) + statusBarHeight
                
                if self.view.frame.origin.y == 0 || self.view.frame.origin.y == navPlusStatusBarHeight {
                    
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
    @objc override func dismissKeyboard() {
        view.endEditing(true)
        userTryingToGiveCurrencyValue = false
        giftMsgTextView.isUserInteractionEnabled = true;
    }
    
    //    MARK: Action functions
    @IBAction func sendGiftAction(_ sender: UIButton) {

        sendGiftButton.isHidden = true
        giftModifyView.isHidden = true
        
        DesignIGiftViewControllerModel().takeSnapShotOfTheView(view: rootView)
        
        sendGiftButton.isHidden = false
        giftModifyView.isHidden = false
    }
    
    @IBAction func cameraAction(_ sender: UIButton) {
        
        let capturePhotoViewController = CapturePhotoViewController(nibName: "CapturePhotoViewController", bundle: nil)
        self.navigationController?.pushViewController(capturePhotoViewController, animated: true)
    }
    
    @IBAction func showHideMsgAction(_ sender: UIButton) {
        
        if giftMsgTextView.isHidden {
            giftMsgTextView.isHidden = false
        } else {
            giftMsgTextView.isHidden = true
        }
    }
    
    @IBAction func addArtAction(_ sender: UIButton) {
        
        let addArtViewController = AddArtViewController(nibName: "AddArtViewController", bundle: nil)
        self.navigationController?.pushViewController(addArtViewController, animated: true)
    }
    
    @IBAction func changeBgColorAction(_ sender: UIButton) {
        
        let chooseBackgroundViewContoller = ChooseBackgroundViewContoller(nibName: "ChooseBackgroundViewContoller", bundle: nil)
        self.navigationController?.pushViewController(chooseBackgroundViewContoller, animated: true)
    }
    
    //    MARK: Supportive functions
    func setupUi() {
        self.title = "Design iGifts"
        
//        Creating a circular button
        sendGiftButton.layer.cornerRadius = 0.5 * sendGiftButton.bounds.size.width;
        
        giftMsgTextView.placeholder = "Write your message here"
        
        GiftCard.shared.backgroundColor = nil
        GiftCard.shared.capturedImage = nil
        capturedPhotoImageView.isHidden = true
        
        giftMsgTextView.font = giftMsgTextView.font?.fontWithName(name: Constants.MAIN_FONT_FAMILY.rawValue)
        
//        The way of retrieving image and show to the user from user documents
//        capturedPhotoImageView.image = UIImage(contentsOfFile: readFileInPath(relativeFilePath: Constants.IMAGES_DIR.rawValue))
    }
    
    @objc func createStickerImage(notification: NSNotification) {
        
        var receivedUserInfo = notification.userInfo
        let imageName = receivedUserInfo![stickerNameNotifiKey] as! String
        
        let image = UIImage(named: imageName)!
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        rootView.addSubview(imageView)
        
        imageView.isUserInteractionEnabled = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGesture))
        imageView.addGestureRecognizer(panGesture)
    }
    
    @objc func panGesture(sender: UIPanGestureRecognizer){
        let point = sender.location(in: view)
        let panGesture = sender.view
        panGesture?.center = point
    }
}
