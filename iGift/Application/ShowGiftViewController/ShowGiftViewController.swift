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
        
        giftImageView.image = UIImage(contentsOfFile: readFileInPath(relativeFilePath: Constants.IMAGES_DIR.rawValue))
    }
    
    //    MARK: Supportive functions
    func setupUi() {
        self.title = "Show Gift"
    }
}
