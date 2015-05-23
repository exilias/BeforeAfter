//
//  CreateGifSampleViewController.swift
//  BeforAfter
//
//  Created by 石井晃 on 2015/05/23.
//  Copyright (c) 2015年 Mobile Interaction Researcher. All rights reserved.
//

import UIKit
import AVFoundation


class CreateGifSampleViewController: UIViewController {

    private var images: [UIImage] = []
    
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var videoInput: AVCaptureInput!
    private var captureSession: AVCaptureSession!
    private var imageOutput: AVCaptureStillImageOutput!
    private var captureDevice: AVCaptureDevice!
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var animatedImageView: FLAnimatedImageView!
    
    
    // MARK: - View cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCamera()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        previewLayer.frame = previewView.bounds;
    }
    
    
    deinit {
        captureSession.removeInput(videoInput)
        captureSession.removeOutput(imageOutput)
        captureSession.stopRunning()
    }
    
    
    // MARK: - User interaction
    
    @IBAction func didTouchTakeButton(sender: AnyObject) {
        let connection = imageOutput.connections.last as! AVCaptureConnection
        
        imageOutput.captureStillImageAsynchronouslyFromConnection(connection, completionHandler: { (imageDataSampleBuffer: CMSampleBuffer!, error: NSError!) -> Void in
            let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
            if let image = UIImage(data: data) {
                self.images += [image]
            }
        })
    }
    
    
    @IBAction func didTouchGifButton(sender: AnyObject) {
        
    }
    
    
    // MARK: - Camera
    
    private func configureCamera() {
        // カメラデバイスの初期化
        captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // 入力の初期化
        var error: NSError?
        videoInput = AVCaptureDeviceInput.deviceInputWithDevice(self.captureDevice, error: &error) as! AVCaptureInput
        
        if let unwrappedError = error {
            println("ERROR: CameraViewController - configureCamera - AVCaptureDeviceInput\nDetail: \(error)")
            return
        }
        
        // セッションの初期化
        captureSession = AVCaptureSession()
        captureSession.addInput(videoInput)
        captureSession.beginConfiguration()
        captureSession.sessionPreset = AVCaptureSessionPreset640x480
        captureSession.commitConfiguration()
        
        // プレビュー表示
        previewLayer = AVCaptureVideoPreviewLayer.layerWithSession(captureSession) as! AVCaptureVideoPreviewLayer
        previewLayer.connection.automaticallyAdjustsVideoMirroring = false
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewView.layer.insertSublayer(previewLayer, atIndex: 0)
        
        // 出力の初期化
        imageOutput = AVCaptureStillImageOutput()
        captureSession.addOutput(imageOutput)
        
        // セッション開始
        captureSession.startRunning()
    }
}
