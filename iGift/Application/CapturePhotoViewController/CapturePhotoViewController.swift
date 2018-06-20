//
//  CapturePhotoViewController.swift
//  iGift
//
//  Created by AnujAroshA on 5/11/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit
import AVFoundation

class CapturePhotoViewController: BaseViewController {
    
    @IBOutlet weak var cameraPreviewView: UIView!
    @IBOutlet weak var captureButton: UIButton!
    
    var session: AVCaptureSession?
    var input: AVCaptureDeviceInput?
    var output: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    //    MARK: UIViewController related
    override func viewDidLoad() {
        super.viewDidLoad()
        print((#file as NSString).lastPathComponent)
        self.setupUi()
        
        openCameraView()
    }
    
    //    MARK: Supportive functions
    func setupUi() {
        self.title = "Capture Photo"

        //        Creating a circular button
        captureButton.layer.cornerRadius = 0.5 * captureButton.bounds.size.width;
    }
    
    //    MARK: Action functions
    @IBAction func captureAction(_ sender: UIButton) {
        
        CapturePhotoViewModel().capturePhoto(stillImageOutput: output!, viewController: self)
    }
    
    func openCameraView() {
        
        //Initialize session an output variables this is necessary
        session = AVCaptureSession()
        output = AVCaptureStillImageOutput()
        
        let camera = CapturePhotoViewModel().getDevice(position: .front)
        
        do {
            input = try AVCaptureDeviceInput(device: camera!)
        } catch let error as NSError {
            print(error)
            input = nil
        }
        
        if(session?.canAddInput(input!) == true){
            session?.addInput(input!)
            output?.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
            
            if(session?.canAddOutput(output!) == true){
                session?.addOutput(output!)
                previewLayer = AVCaptureVideoPreviewLayer(session: session!)
                previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                previewLayer?.frame = self.view.bounds
                cameraPreviewView.layer.addSublayer(previewLayer!)
                session?.startRunning()
            }
        }
    }
}
