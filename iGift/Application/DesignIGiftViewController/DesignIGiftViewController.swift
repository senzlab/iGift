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
    @IBOutlet weak var fancyOverlayView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    var userTryingToGiveCurrencyValue: Bool = false
    var keyboardHeight: CGFloat!
    
    var user: User? = nil
    let currencyType = "Rs "
    
    //    MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print((#file as NSString).lastPathComponent)
        self.setupUi()
        
        currencyValueTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(DesignIGiftViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DesignIGiftViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(createStickerImage(notification:)), name: .tappedOnArtItem, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isHidden = true

        if GiftCard.shared.capturedImage != nil {
            capturedPhotoImageView.isHidden = false
            capturedPhotoImageView.image = GiftCard.shared.capturedImage
            fancyOverlayView.isHidden = false
        }
        else {
            capturedPhotoImageView.isHidden = true
            fancyOverlayView.isHidden = true
        }
        
        if GiftCard.shared.backgroundColor != nil {
            rootView.backgroundColor = GiftCard.shared.backgroundColor
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.navigationController?.navigationBar.isHidden = false
    }

    //    MARK: Action functions
    @IBAction func sendGiftAction(_ sender: UIButton) {
        let amount = currencyValueTextField.text!.replacingOccurrences(of: currencyType, with: "", options: NSString.CompareOptions.literal, range: nil)
        sendGiftButton.isHidden = true
        giftModifyView.isHidden = true
        backButton.isHidden = true
        
        let screenshot = rootView.takeSnapshot()
        let compressedImageData = screenshot.lowestQualityJPEGNSData
        let blob = compressedImageData.base64EncodedString()
        let uid = NSUUID().uuidString
        
        sendGiftButton.isHidden = false
        giftModifyView.isHidden = false
        backButton.isHidden = false
        
        let z = Httpz.instance.pushSenz(senz: SenzUtil.instance.transferSenz(amount: amount, blob: blob, to: user!.phone))
        if z == nil {
            // fail to send igift
            ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Fail to send iGift")
        } else {
            if (SenzUtil.instance.verifyStatus(z: z!)) {
                // save image
                let filename = uid + ".jpeg"
                createFileInPath(relativeFilePath: Constants.IMAGES_DIR.rawValue, fileName: filename, imageData: compressedImageData as Data)
                
                // save igift
                let ig = Igift(id: 1)
                ig.uid = uid
                ig.amount = amount
                ig.account = PreferenceUtil.instance.get(key: PreferenceUtil.ACCOUNT)
                ig.state = "TRANSFER"
                ig.isMyIgift = true
                ig.user = user!.phone
                ig.timestamp = TimeUtil.sharedInstance.timestamp()
                SenzDb.instance.createIgift(igift: ig)
                
                // exit view controller
                navigationController?.popViewController(animated: true)
            } else {
                // fail
                ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Fail to send iGift")
            }
        }
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
    
    @IBAction func backAction(_ sender: UIButton) {
        goBack(animated: true)
    }
    
    //    MARK: Notification observer selectors
    
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
    
    @objc func createStickerImage(notification: NSNotification) {
        var receivedUserInfo = notification.userInfo
        let imageName = receivedUserInfo![stickerNameNotifiKey] as! String
        
        let image = UIImage(named: imageName)!
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: (screenWidth/2 - 35), y: 20, width: 70, height: 70)
        rootView.addSubview(imageView)
        
        imageView.isUserInteractionEnabled = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGesture))
        imageView.addGestureRecognizer(panGesture)
    }
    
    //    MARK: Gesture selectors

    @objc override func dismissKeyboard() {
        view.endEditing(true)
        userTryingToGiveCurrencyValue = false
        giftMsgTextView.isUserInteractionEnabled = true;
    }
    
    @objc func panGesture(sender: UIPanGestureRecognizer){
        let point = sender.location(in: view)
        let panGesture = sender.view
        panGesture?.center = point
        
//        If art image is going to Amount section, hide it
        if (point.y > screenHeight*2/3) {
            sender.view?.isHidden = true
        }
    }
    
    //    MARK: UITextFieldDelegate functions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == currencyValueTextField {
            userTryingToGiveCurrencyValue = true
            giftMsgTextView.isUserInteractionEnabled = false;
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == currencyValueTextField{
            if let text = textField.text{
                if text == currencyType{
                    textField.text = ""
                    return true
                }
                textField.text = currencyType + text.replacingOccurrences(of: currencyType, with: "", options: NSString.CompareOptions.literal, range: nil)
            }
        }
        
        return true
    }
    
    //    MARK: Supportive functions
    
    func setupUi() {
        self.title = "New iGift"
        
        sendGiftButton.layer.cornerRadius = 0.5 * sendGiftButton.bounds.size.width;
        
        giftMsgTextView.placeholder = "Write your message here"
        
        GiftCard.shared.backgroundColor = nil
        GiftCard.shared.capturedImage = nil
        capturedPhotoImageView.isHidden = true
        
        giftMsgTextView.font = giftMsgTextView.font?.fontWithName(name: Constants.MAIN_FONT_FAMILY.rawValue)
        currencyValueTextField.font = currencyValueTextField.font?.fontWithName(name: Constants.MAIN_FONT_FAMILY.rawValue)
    }
}








