//
//  DesignIGiftViewController.swift
//  iGift
//
//  Created by AnujAroshA on 5/9/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class DesignIGiftViewController: BaseViewController, UITextFieldDelegate, AlertViewControllerDelegate {
    
    @IBOutlet weak var sendGiftButton: UIButton!
    @IBOutlet weak var currencyValueTextField: UITextField!
    @IBOutlet weak var giftMsgTextView: UITextView!
    @IBOutlet weak var capturedPhotoImageView: UIImageView!
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var giftModifyView: UIView!
    @IBOutlet weak var fancyOverlayView: UIView!
    
    var userTryingToGiveCurrencyValue: Bool = false
    var keyboardHeight: CGFloat!
    
    var user: User? = nil
    let currencyType = "Rs "
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        UIApplication.shared.isStatusBarHidden = true

        if GiftCard.shared.capturedImage != nil {
            capturedPhotoImageView.isHidden = false
            capturedPhotoImageView.image = GiftCard.shared.capturedImage
            fancyOverlayView.isHidden = false
        } else {
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
        UIApplication.shared.isStatusBarHidden = false
    }

    @IBAction func sendGiftAction(_ sender: UIButton) {
        let amount = currencyValueTextField.text!.replacingOccurrences(of: currencyType, with: "", options: NSString.CompareOptions.literal, range: nil)
        let message = giftMsgTextView.text!
        let status = ViewControllerUtil.validateIGift(amount: amount, message: message)
        if (status == 0) {
            giftSendConfirmation(amount: amount)
        } else if(status == -1) {
            ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "iGift transaction amount should exceed 100 rupees")
        } else if(status == -2) {
            ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "iGift transaction amount should not exceed 10,000 rupees")
        } else if(status == -3) {
            ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Empty iGift amount")
        } else if(status == -4) {
            ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Please write igift message to send")
        }
    }
    
    @IBAction func cameraAction(_ sender: UIButton) {
        let capturePhotoViewController = CapturePhotoViewController(nibName: "CapturePhotoViewController", bundle: nil)
        self.navigationController?.pushViewController(capturePhotoViewController, animated: false)
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
        self.navigationController?.pushViewController(addArtViewController, animated: false)
    }
    
    @IBAction func changeBgColorAction(_ sender: UIButton) {
        let chooseBackgroundViewContoller = ChooseBackgroundViewContoller(nibName: "ChooseBackgroundViewContoller", bundle: nil)
        self.navigationController?.pushViewController(chooseBackgroundViewContoller, animated: false)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        goBack(animated: false)
    }
    
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
    
    @objc override func dismissKeyboard() {
        view.endEditing(true)
        userTryingToGiveCurrencyValue = false
        giftMsgTextView.isUserInteractionEnabled = true;
    }
    
    @objc func panGesture(sender: UIPanGestureRecognizer){
        let point = sender.location(in: view)
        let panGesture = sender.view
        panGesture?.center = point
        
        // If art image is going to Amount section, hide it
        if (point.y > screenHeight*2/3) {
            sender.view?.isHidden = true
        }
    }
    
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
    
    func setupUi() {
        self.title = "New igift"
        
        sendGiftButton.layer.cornerRadius = 0.5 * sendGiftButton.bounds.size.width;

        GiftCard.shared.backgroundColor = nil
        GiftCard.shared.capturedImage = nil
        capturedPhotoImageView.isHidden = true
        
        giftMsgTextView.placeholder = "Write your message here"
        giftMsgTextView.font = giftMsgTextView.font?.fontWithName(name: Constants.MAIN_FONT_FAMILY.rawValue)
        currencyValueTextField.font = currencyValueTextField.font?.fontWithName(name: Constants.MAIN_FONT_FAMILY.rawValue)
    }
    
    func sendIgift(amount: String) {
        let imgData = self.captureScreen()
        let blob = imgData.base64EncodedString()
        let cid = NSUUID().uuidString
        let uid = SenzUtil.instance.uid(zAddress: PreferenceUtil.instance.get(key: PreferenceUtil.PHONE_NUMBER))
        let senz = SenzUtil.instance.transferSenz(amount: amount, blob: blob, to: self.user!.phone, cid: cid)
        
        SenzProgressView.shared.showProgressView(self.view)
        DispatchQueue.global(qos: .userInitiated).async {
            let z = Httpz.instance.pushSenz(senz: senz)
            if z == nil {
                DispatchQueue.main.async {
                    // fail to send igift
                    SenzProgressView.shared.hideProgressView()
                    ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Fail to send igift")
                }
            } else {
                if (SenzUtil.instance.verifyStatus(z: z!)) {
                    // save igift
                    self.saveIGift(uid: uid, cid: cid, amount: amount, data: imgData)
                    
                    DispatchQueue.main.async {
                        // exit view controller
                        SenzProgressView.shared.hideProgressView()
                        
                        let viewContUtil = ViewControllerUtil()
                        viewContUtil.delegate = self
                        viewContUtil.showAlertWithSingleActions(alertTitle: "Success", alertMessage: "Successfully sent igift", viewController: self)
                    }
                } else {
                    DispatchQueue.main.async {
                        // fail to send igift
                        SenzProgressView.shared.hideProgressView()
                        ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Fail to send igift")
                    }
                }
            }
        }
    }
    
    func captureScreen() -> NSData {
        sendGiftButton.isHidden = true
        giftModifyView.isHidden = true
        
        let screenshot = rootView.takeSnapshot()
        let compressedImageData = screenshot.lowestQualityJPEGNSData
        
        sendGiftButton.isHidden = false
        giftModifyView.isHidden = false
        
        return compressedImageData
    }
    
    func saveIGift(uid: String, cid: String, amount: String, data: NSData) {
        // save image
        let filename = uid + ".jpeg"
        _ = createFileInPath(relativeFilePath: Constants.IMAGES_DIR.rawValue, fileName: filename, imageData: data as Data)
        
        // save iGift
        let ig = Igift(id: 1)
        ig.uid = uid
        ig.amount = amount
        ig.account = PreferenceUtil.instance.get(key: PreferenceUtil.ACCOUNT)
        ig.state = "TRANSFER"
        ig.isMyIgift = true
        ig.cid = cid
        ig.user = user!.phone
        ig.timestamp = TimeUtil.sharedInstance.timestamp()
        _ = SenzDb.instance.createIgift(igift: ig)
    }
    
    func giftSendConfirmation(amount: String) {
        var enteredPassword:String = ""
        let alertController = UIAlertController(title: "Enter Password", message: "", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Done", style: .default, handler: { alert -> Void in
            let savedPassword = PreferenceUtil.instance.get(key: PreferenceUtil.PASSWORD)
            enteredPassword = alertController.textFields![0].text!
            if savedPassword == enteredPassword {
                self.sendIgift(amount: amount)
            } else {
                ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Invalid password")
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.isSecureTextEntry = true
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func executeTaskForAction(actionTitle: String) {
        if actionTitle == "OK" {
            DispatchQueue.main.async {
                // exit view controller
                self.navigationController?.popViewController(animated: false)
            }
        }
    }
}








