//
//  CameraViewController.swift
//  BeforAfter
//
//  Created by 石井晃 on 2015/05/23.
//  Copyright (c) 2015年 Mobile Interaction Researcher. All rights reserved.
//

import UIKit
import ImageIO
import MobileCoreServices

class CameraViewController: UIViewController {

    private var images: [UIImage] = []
    private var cameraManager = CameraManager.new()
    private var timer: NSTimer?
    private var state = State.Init
    private var gifPath: String?
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var takeButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    
    enum State {
        case Init, Recording, Complete
    }
    
    
    // MARK: - View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeButton.setTitle(ion_close, forState: .Normal)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        cameraManager.setPreview(previewView)
    }

    
    // MARK: - UI
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return .Slide
    }
    
    
    // MARK: - User interaction
    
    @IBAction func didTouchTakeButton(sender: AnyObject) {
        switch state {
        case .Init:
            state = .Recording
            takeButton.setTitle("完了", forState: .Normal)
            timer = NSTimer(timeInterval: 0.5, target: self, selector: Selector("takePhoto"), userInfo: nil, repeats: true)
            NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
            
        case .Recording:
            state = .Complete
            takeButton.setTitle("送信", forState: .Normal)
            timer?.invalidate()
            timer = nil
            createGIF()
            
        case .Complete:
            BAAPIManager.uploadGIFWithPath(gifPath, success: nil, failure: nil)
            break
        }
    }
    
    
    @IBAction func didTouchCloseButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - Camera
    
    func takePhoto() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            self.images += [self.cameraManager.rotatedVideoImage()]
            return
        })
    }
    
    
    private func createGIF() {
        if let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last?.stringByAppendingPathComponent("\(arc4random_uniform(20209449)).gif") {
            let frameProperties: [String: AnyObject] = [kCGImagePropertyGIFDelayTime as String: NSNumber(int: 2)]
            let gifProperties: [String: AnyObject] = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: NSNumber(int: 0)]]
            
            let destination = CGImageDestinationCreateWithURL(NSURL(fileURLWithPath: path), kUTTypeGIF, images.count, nil)
            
            for image in images {
                CGImageDestinationAddImage(destination, image.CGImage, frameProperties)
            }
            
            CGImageDestinationSetProperties(destination, gifProperties)
            CGImageDestinationFinalize(destination)
            
            var animatedImageView = FLAnimatedImageView(frame: previewView.bounds)
            animatedImageView.animatedImage = FLAnimatedImage(GIFData: NSData(contentsOfFile: path))
            previewView.addSubview(animatedImageView)
            
            gifPath = path
        }
    }
    
}
