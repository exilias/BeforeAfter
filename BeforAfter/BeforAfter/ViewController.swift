//
//  ViewController.swift
//  BeforAfter
//
//  Created by 石井晃 on 2015/05/23.
//  Copyright (c) 2015年 Mobile Interaction Researcher. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var animatedImageView: FLAnimatedImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animatedImage = FLAnimatedImage(GIFData: NSData(contentsOfURL: NSURL(string: "http://raphaelschaad.com/static/nyan.gif")!))
        animatedImageView.animatedImage = animatedImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

