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
        
        setupUi()
        setupTabs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupUi() {
        // tabbar
        self.tabBar.tintColor = UIColor.fromHex(HexColors.PRIMARY_COLOR.rawValue)
        self.tabBar.backgroundColor = UIColor.white
        
        // status bar
        let view = UIView(frame: UIApplication.shared.statusBarFrame)
        view.backgroundColor = UIColor.fromHex(HexColors.PRIMARY_COLOR.rawValue)
        self.view.addSubview(view)
        
        // title
        self.title = "iGifts"
    }
    
    func setupTabs() {
        // add tabs
        let receivedViewController = IGiftsReceivedViewController(nibName: "IGiftsReceivedViewController", bundle: nil)
        let sentViewController = IGiftsSentViewController(nibName: "IGiftsSentViewController", bundle: nil)
        receivedViewController.tabBarItem = UITabBarItem(title: "Received", image: UIImage(named: "received"), tag: 0)
        sentViewController.tabBarItem = UITabBarItem(title: "Sent", image: UIImage(named: "sent"), tag: 0)
        let controllers = [receivedViewController, sentViewController]
        self.viewControllers = controllers
    }

}
