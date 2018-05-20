//
//  IGiftsViewController.swift
//  iGift
//
//  Created by Isuru_Jayathissa on 5/17/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class IGiftsViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.tintColor = UIColor.fromHex(HexColors.PRIMARY_COLOR.rawValue)
        self.tabBar.backgroundColor = UIColor.white
        
        let receivedViewController = IGiftsReceivedViewController(nibName: "IGiftsReceivedViewController", bundle: nil)
        let sentViewController = IGiftsSentViewController(nibName: "IGiftsSentViewController", bundle: nil)
        receivedViewController.tabBarItem = UITabBarItem(title: "Received", image: UIImage(named: "received"), tag: 0)
        sentViewController.tabBarItem = UITabBarItem(title: "Sent", image: UIImage(named: "sent"), tag: 0)
  
        let controllers = [receivedViewController, sentViewController]
        self.viewControllers = controllers
        
        self.title = "iGifts"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
