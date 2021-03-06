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
        UIApplication.shared.isStatusBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
        UIApplication.shared.isStatusBarHidden = false
    }
    
    //    MARK: Action functions
    @IBAction func redeemAction(_ sender: UIButton) {
        let bankListViewController = BankListViewController(nibName: "BankListViewController", bundle: nil)
        bankListViewController.iGift = iGift
        self.navigationController?.pushViewController(bankListViewController, animated: false)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        goBack(animated: false)
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
                SenzProgressView.shared.showProgressView((self.view))
                fetchImage()
            }
        }
    }
    
    func fetchImage() {
        // download image
        SenzProgressView.shared.showProgressView((self.navigationController?.view)!)
        DispatchQueue.global(qos: .userInitiated).async {
            let senz = SenzUtil.instance.blobSenz(uid: self.iGift!.uid)

            // post to contractz
            let dict = ["Uid": self.iGift!.uid, "Msg": senz]
            Httpz.instance.doPost(param: dict, onComplete: {(senzes: [Senz]) -> Void in
                if (senzes.count > 0 && senzes.first!.attr["#status"] == "200") {
                    // fetch done
                    // save image
                    let dataDecoded : Data = Data(base64Encoded: senzes.first!.attr["#blob"]!)!
                    _ = createFileInPath(relativeFilePath: Constants.IMAGES_DIR.rawValue, fileName: self.iGift!.uid + ".jpeg", imageData: dataDecoded)
                    
                    // mark as viewed
                    _ = SenzDb.instance.markAsViewed(id: self.iGift!.uid)
                    
                    DispatchQueue.main.async {
                        SenzProgressView.shared.hideProgressView()
                        let decodedimage = UIImage(data: dataDecoded)
                        self.giftImageView.image = decodedimage
                    }
                } else {
                    // fail
                    DispatchQueue.main.async {
                        SenzProgressView.shared.hideProgressView()
                        ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Fail to download igift")
                    }
                }
            })
        }
    }
}
