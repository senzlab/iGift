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
    
    //    MARK: UIViewController related
    override func viewDidLoad() {
        super.viewDidLoad()
        print((#file as NSString).lastPathComponent)
        self.setupUi()
        
//        Previewing an image by taking from application documents directory
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
    
    //    MARK: Action functions
    @IBAction func redeemAction(_ sender: UIButton) {
        
    }
    
    //    MARK: Supportive functions
    func setupUi() {
        self.title = "Show Gift"
    }
}
