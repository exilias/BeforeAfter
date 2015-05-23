//
//  CreateGifSampleViewController.swift
//  BeforAfter
//
//  Created by 石井晃 on 2015/05/23.
//  Copyright (c) 2015年 Mobile Interaction Researcher. All rights reserved.
//

import UIKit
import AVFoundation
import ImageIO
import MobileCoreServices


class CreateGifSampleViewController: UIViewController {

    private var images: [UIImage] = []
    private var cameraManager = CameraManager.new()
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var animatedImageView: FLAnimatedImageView!
    
    
    // MARK: - View cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraManager.setPreview(previewView)
    }
    
    
    // MARK: - User interaction
    
    @IBAction func didTouchTakeButton(sender: AnyObject) {        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            self.images += [self.cameraManager.rotatedVideoImage()]
            return
        })
    }
    
    
    @IBAction func didTouchGifButton(sender: AnyObject) {
        if let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last?.stringByAppendingPathComponent("\(arc4random_uniform(20209449)).gif") {
            let frameProperties: [String: AnyObject] = [kCGImagePropertyGIFDelayTime as String: NSNumber(int: 2)]
            let gifProperties: [String: AnyObject] = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: NSNumber(int: 0)]]
            
            let destination = CGImageDestinationCreateWithURL(NSURL(fileURLWithPath: path), kUTTypeGIF, images.count, nil)
            
            for image in images {
                CGImageDestinationAddImage(destination, image.CGImage, frameProperties)
            }
            
            CGImageDestinationSetProperties(destination, gifProperties)
            CGImageDestinationFinalize(destination)
            
            animatedImageView.animatedImage = FLAnimatedImage(GIFData: NSData(contentsOfFile: path))
        }
    }

}
