//
//  ShowGiftViewController.swift
//  iGift
//
//  Created by AnujAroshA on 5/16/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class ShowGiftViewController: BaseViewController {

    var iGift: Igift? = nil

    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var redeemButton: CircleButton!
    
    //    MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
        self.setupPreview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //    MARK: Action functions
    @IBAction func redeemAction(_ sender: UIButton) {
        let redeemViewController = RedeemViewController(nibName: "RedeemViewController", bundle: nil)
        redeemViewController.iGift = iGift
        redeemViewController.bank = Bank(code: "7278", name: "Sampath bank")
        self.navigationController?.pushViewController(redeemViewController, animated: true)
        
        //let bankListViewController = BankListViewController(nibName: "BankListViewController", bundle: nil)
        //bankListViewController.iGift = iGift
        //self.navigationController?.pushViewController(bankListViewController, animated: true)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        goBack(animated: true)
    }
    
    //    MARK: Supportive function
    func setupUi() {
        self.title = "Show Gift"
        
        if iGift!.isMyIgift {
            redeemButton.isHidden = true
        } else {
            if iGift!.state == "TRANSFER" {
                redeemButton.isHidden = false
            } else {
                redeemButton.isHidden = true
            }
        }
    }
    
    func setupPreview() {
        if iGift != nil {
            if iGift!.isViewed {
                giftImageView.image = UIImage(contentsOfFile: readFileInPath(relativeFilePath: Constants.IMAGES_DIR.rawValue, fileName: iGift!.uid + ".jpeg"))
            } else {
                fetchImage()
            }
        }
    }
    
    func fetchImage() {
        // download image
        DispatchQueue.main.async {
            let senz = SenzUtil.instance.blobSenz(uid: self.iGift!.uid)
            let z = Httpz.instance.pushSenz(senz: senz)
            if z == nil {
                // reg fail
                DispatchQueue.main.async {
                    ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Fail to download iGift")
                }
            } else {
                // fetch done
                // save image
                let rSenz = SenzUtil.instance.parse(msg: z!)
                let dataDecoded : Data = Data(base64Encoded: rSenz.attr["#blob"]!)!
                createFileInPath(relativeFilePath: Constants.IMAGES_DIR.rawValue, fileName: self.iGift!.uid + ".jpeg", imageData: dataDecoded)
                
                // mark as viewed
                SenzDb.instance.markAsViewed(id: self.iGift!.uid)
                
                DispatchQueue.main.async {
                    let decodedimage = UIImage(data: dataDecoded)
                    self.giftImageView.image = decodedimage
                }
            }
        }
    }
}
