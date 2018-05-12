//
//  DesignIGiftViewControllerModel.swift
//  iGift
//
//  Created by AnujAroshA on 5/12/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class DesignIGiftViewControllerModel: NSObject {
    
    func takeScreenshot(_ shouldSave: Bool = true) -> UIImage? {
        
        var screenshotImage :UIImage?
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image = screenshotImage, shouldSave {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        
        return screenshotImage
    }
}
