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
            timer = NSTimer(timeInterval: 0.1, target: self, selector: Selector("takePhoto"), userInfo: nil, repeats: true)
            NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
            
        case .Recording:
            state = .Complete
            takeButton.setTitle("送信", forState: .Normal)
            timer?.invalidate()
            timer = nil
            createGIF()
            
        case .Complete:
            uploadPhoto()
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
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            if let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last?.stringByAppendingPathComponent("\(arc4random_uniform(20209449)).gif") {
                let frameProperties: [String: AnyObject] = [kCGImagePropertyGIFDelayTime as String: NSNumber(float: 0.1)]
                let gifProperties: [String: AnyObject] = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: NSNumber(int: 0)]]
                
                
                
                var div = 1
                if self.images.count > 50 {
                    div = self.images.count / 50
                    
                    if div == 0 {
                        div = 1
                    }
                }
                
                var counter = 0
                var photoCount = 0
                for image in self.images {
                    counter++
                    if counter == div {
                        photoCount++
                    }
                }
                
                let destination = CGImageDestinationCreateWithURL(NSURL(fileURLWithPath: path), kUTTypeGIF, photoCount-1, nil)
                
                var c = 0
                counter = 0
                for image in self.images {
                    counter++
                    c++
                    if counter == div {
                        CGImageDestinationAddImage(destination, image.CGImage, frameProperties)
                        counter = 0
                        
                        println("\(c)")
                    }
                }
                
                CGImageDestinationSetProperties(destination, gifProperties)
                CGImageDestinationFinalize(destination)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var animatedImageView = FLAnimatedImageView(frame: self.previewView.bounds)
                    animatedImageView.clipsToBounds = true
                    animatedImageView.contentMode = .ScaleAspectFill
                    animatedImageView.animatedImage = FLAnimatedImage(GIFData: NSData(contentsOfFile: path))
                    self.previewView.addSubview(animatedImageView)
                    
                    self.gifPath = path
                })
            }
        })
    }
    
    
    private func uploadPhoto() {
        SVProgressHUD.showWithStatus("送信中...", maskType: .Black)
        
        BAAPIManager.uploadGIFWithPath(gifPath, success: { () -> Void in
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                SVProgressHUD.showSuccessWithStatus("投稿しました！")
            })
        }, failure: { (error: NSError?) -> Void in
            SVProgressHUD.showErrorWithStatus("失敗しました")
            println("ERROR: \(error)")
        })
    }
}
