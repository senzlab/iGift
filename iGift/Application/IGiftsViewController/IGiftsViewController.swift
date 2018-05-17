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

        
        let receivedViewController = IGiftsReceivedViewController(nibName: "IGiftsReceivedViewController", bundle: nil)
        let sentViewController = IGiftsSentViewController(nibName: "IGiftsSentViewController", bundle: nil)
        
        self.tabBar.tintColor = UIColor.fromHex(HexColors.PRIMARY_COLOR.rawValue)
        self.tabBar.backgroundColor = UIColor.white
        receivedViewController.tabBarItem = UITabBarItem(title: "Received", image: UIImage(named: "received"), tag: 0)
        sentViewController.tabBarItem = UITabBarItem(title: "Sent", image: UIImage(named: "sent"), tag: 0)
        
//        receivedViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
//        sentViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 1)
        
        let controllers = [receivedViewController, sentViewController]
        self.viewControllers = controllers
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
