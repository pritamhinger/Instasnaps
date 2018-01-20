//
//  CameraController.swift
//  Instasnaps
//
//  Created by Pritam Hinger on 20/01/18.
//  Copyright © 2018 AppDevelapp. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController {
    
    let captureButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "capture_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleImageCapture), for: .touchUpInside)
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "right_arrow_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(cancelCaptureSession), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCameraSession()
        setupCameraControls()
    }
    
    fileprivate func setupCameraControls() {
        view.addSubview(captureButton)
        captureButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, topPadding: 0, leftPadding: 0, bottomPadding: 24, rightPadding: 0, width: 80, height: 80)
        captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topPadding: 12, leftPadding: 0, bottomPadding: 12, rightPadding: 0, width: 50, height: 50)
    }
    
    @objc fileprivate func cancelCaptureSession(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func handleImageCapture(){
        print("Capturing image")
    }
    
    fileprivate func setUpCameraSession() {
        let captureSession = AVCaptureSession()
        
        // Adding Input to capture device
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("Unable to get the device")
            return
        }
        
        do{
            let captureSessionInput = try AVCaptureDeviceInput(device: device)
            if(captureSession.canAddInput(captureSessionInput)){
                captureSession.addInput(captureSessionInput)
            }
        }catch let err{
            print("Error occured while adding input", err)
        }
        
        // Adding Output to Capture Device
        let captureSessionOutput = AVCapturePhotoOutput()
        if captureSession.canAddOutput(captureSessionOutput) {
            captureSession.addOutput(captureSessionOutput)
        }
        
        // Adding Preview Layer
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
}
