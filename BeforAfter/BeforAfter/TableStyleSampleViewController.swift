//
//  TableStyleSampleViewController.swift
//  BeforAfter
//
//  Created by 石井晃 on 2015/05/23.
//  Copyright (c) 2015年 Mobile Interaction Researcher. All rights reserved.
//

import UIKit

class TableStyleSampleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - TableView data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200.0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TableStyleSampleViewCell
        
        cell.animatedImageURL = NSURL(string: "http://raphaelschaad.com/static/nyan.gif")
        
        return cell
    }
    
    
    // MARK: - TableView delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}



class TableStyleSampleViewCell: UITableViewCell {
    
    var animatedImageURL: NSURL? {
        didSet {
            if let unwrappedURL = animatedImageURL {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    let animatedImage = FLAnimatedImage(GIFData: NSData(contentsOfURL: unwrappedURL))
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.animatedImageView.animatedImage = animatedImage
                        return
                    })
                })
            }
        }
    }
    
    @IBOutlet private weak var animatedImageView: FLAnimatedImageView!
}
