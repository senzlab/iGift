//
//  NavigationViewController.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/8/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import Foundation
import UIKit

class NavigationViewController : UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialView()
        // Do any additional setup after loading the view.
    }

    func loadInitialView() {
        let homeViewController = HomeViewController(nibName: "HomeViewController", bundle: nil)
        self.pushViewController(homeViewController, animated: true)
    }
}
