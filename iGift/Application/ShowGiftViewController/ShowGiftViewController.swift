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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
        self.setupPreview()
    }
    
    @IBAction func redeemAction(_ sender: UIButton) {
        
    }

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
                // download image
                let senz = SenzUtil.instance.blobSenz(uid: iGift!.uid)
                let z = Httpz.instance.pushSenz(senz: senz)
                if z == nil {
                    // reg fail
                    ViewControllerUtil.showAlert(alertTitle: "Error", alertMessage: "Fail to download iGift")
                } else {
                    // fetch done
                    // save image
                    let rSenz = SenzUtil.instance.parse(msg: z!)
                    let dataDecoded : Data = Data(base64Encoded: rSenz.attr["#blob"]!)!
                    createFileInPath(relativeFilePath: Constants.IMAGES_DIR.rawValue, fileName: iGift!.uid + ".jpeg", imageData: dataDecoded)
                    
                    let decodedimage = UIImage(data: dataDecoded)
                    giftImageView.image = decodedimage
                    
                    // mark as viewed
                    SenzDb.instance.markAsViewed(id: iGift!.uid)
                }
            }
        }
    }
}
