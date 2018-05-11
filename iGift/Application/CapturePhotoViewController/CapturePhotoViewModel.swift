//
//  CapturePhotoViewModel.swift
//  iGift
//
//  Created by AnujAroshA on 5/11/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit
import AVFoundation

class CapturePhotoViewModel: NSObject {
    
    //Get the device (Front or Back)
    func getDevice(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices: NSArray = AVCaptureDevice.devices() as NSArray;
        for de in devices {
            let deviceConverted = de as! AVCaptureDevice
            if(deviceConverted.position == position) {
                return deviceConverted
            }
        }
        return nil
    }
    
    func capturePhoto(stillImageOutput: AVCaptureStillImageOutput, viewController: UIViewController) {
        
        var videoConnection :AVCaptureConnection?

        videoConnection = stillImageOutput.connection(with: AVMediaType.video)

        stillImageOutput.captureStillImageAsynchronously(from: videoConnection!, completionHandler: {(imageSampleBuffer, error) in
            if (imageSampleBuffer != nil) {
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageSampleBuffer as! CMSampleBuffer)
                let image: UIImage = UIImage(data: imageData!)!
                GiftCard.shared.capturedImage = image
                viewController.navigationController?.popViewController(animated: true)
            }
        })
    }
}
