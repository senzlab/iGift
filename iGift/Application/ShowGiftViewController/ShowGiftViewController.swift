//
//  ShowGiftViewController.swift
//  iGift
//
//  Created by AnujAroshA on 5/16/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class ShowGiftViewController: BaseViewController {

    @IBOutlet weak var giftImageView: UIImageView!
    
    //    MARK: UIViewController related
    override func viewDidLoad() {
        super.viewDidLoad()
        print((#file as NSString).lastPathComponent)
        self.setupUi()
        
//        Previewing an image by taking from application documents directory
//        giftImageView.image = UIImage(contentsOfFile: readFileInPath(relativeFilePath: Constants.IMAGES_DIR.rawValue))
        
//        Previewing an image from remote URL. Added anujarosha.lk in Info.plist for testing
        giftImageView.downloadedFrom(link: "http://anujarosha.lk/images/original/my_trip_to_MtLavinia2.jpg")
    }
    
    //    MARK: Supportive functions
    func setupUi() {
        self.title = "Show Gift"
    }
}
