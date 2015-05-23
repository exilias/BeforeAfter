//
//  HomeViewController.swift
//  BeforAfter
//
//  Created by 石井晃 on 2015/05/23.
//  Copyright (c) 2015年 Mobile Interaction Researcher. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - TableView data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MainCell", forIndexPath: indexPath) as! HomeViewTableCell
        
        cell.animatedImageURL = NSURL(string: "http://raphaelschaad.com/static/nyan.gif")
        
        return cell
    }
    
    // MARK: - TableView delegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.frame.size.width + 37 + 60
    }
    
    
}


class HomeViewTableCell: UITableViewCell {
    
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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var animatedImageView: FLAnimatedImageView!
    
    
    override func awakeFromNib() {
        likeButton.setTitle(ion_ios_heart_outline, forState: .Normal)
        commentButton.setTitle(ion_ios_chatbubble_outline, forState: .Normal)
    }
    
    
    @IBAction func didTouchLikeButton(sender: AnyObject) {
        println("like")
    }
    
    
    @IBAction func didTouchCommentButton(sender: AnyObject) {
        println("comment")
    }
}