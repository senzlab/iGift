//
//  DeviceModel.swift
//  iGift
//
//  Created by AnujAroshA on 5/11/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import Foundation
import UIKit

let statusBarHeight = UIApplication.shared.statusBarFrame.height;

func navigationBarHeight(viewController: UIViewController) -> CGFloat {
    return (viewController.navigationController?.navigationBar.frame.size.height)!
}
