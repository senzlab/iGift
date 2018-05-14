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
            
            let compressedImageData = image.lowestQualityJPEGNSData
            
//            Save in the photo library
            UIImageWriteToSavedPhotosAlbum(UIImage(data: compressedImageData as Data)!, nil, nil, nil)
            
//            Save inside the user documents directory
            let fileWriteStatus = createFileInPath(relativeFilePath: Constants.IMAGES_DIR.rawValue, fileName: "uniqueid_1.jpeg", imageData: compressedImageData as Data)
            print((#file as NSString).lastPathComponent, " # fileWriteStatus = ", fileWriteStatus)
        }
        
        return screenshotImage
    }
}
