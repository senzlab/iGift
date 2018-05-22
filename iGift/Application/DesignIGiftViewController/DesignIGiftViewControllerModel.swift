//
//  DesignIGiftViewControllerModel.swift
//  iGift
//
//  Created by AnujAroshA on 5/12/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class DesignIGiftViewControllerModel: NSObject {
    
    func takeScreenshot(_ shouldSave: Bool = true, viewController:UIViewController) -> UIImage? {
        
        var screenshotImage :UIImage?
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let neglectHeight = statusBarHeight + navigationBarHeight(viewController: viewController)
        
//        Crop the captured image without navigation and status bar
        screenshotImage = screenshotImage?.cropWithoutNavigationAndStatusBar(rect: CGRect(x: 0.0, y: neglectHeight, width: screenWidth, height: (screenHeight - neglectHeight)))
        
        if let image = screenshotImage, shouldSave {
            let compressedImageData = image.lowestQualityJPEGNSData
            
//            Save in the photo library
            UIImageWriteToSavedPhotosAlbum(UIImage(data: compressedImageData as Data)!, nil, nil, nil)
            
//            Save inside the user documents directory
            let fileWriteStatus = createFileInPath(relativeFilePath: Constants.IMAGES_DIR.rawValue, fileName: "uniqueid.jpeg", imageData: compressedImageData as Data)
            print((#file as NSString).lastPathComponent, " # fileWriteStatus = ", fileWriteStatus)
        }
        
        return screenshotImage
    }
    
    func takeSnapShotOfTheView(view: UIView, fileName: String) -> String? {
        var screenshotImage :UIImage?
        screenshotImage = view.takeSnapshot()
        
        if let image = screenshotImage {
            let compressedImageData = image.lowestQualityJPEGNSData

//            Save inside the user documents directory
            let fileWriteStatus = createFileInPath(relativeFilePath: Constants.IMAGES_DIR.rawValue, fileName: fileName, imageData: compressedImageData as Data)
            
            return compressedImageData.base64EncodedString()
        }
        
        return nil
    }
    
    func captureScreen(view: UIView) -> String {
        let screenshot = view.takeSnapshot()
        let compressedImageData = screenshot.lowestQualityJPEGNSData
        return compressedImageData.base64EncodedString()
    }
}
