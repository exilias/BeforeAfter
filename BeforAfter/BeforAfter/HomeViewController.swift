//
//  HomeViewController.swift
//  BeforAfter
//
//  Created by 石井晃 on 2015/05/23.
//  Copyright (c) 2015年 Mobile Interaction Researcher. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var timelines: [Timeline] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - View cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        BAAPIManager.getTimelineWithSuccess({ (timelines: [AnyObject]!) -> Void in
            var timelinesBuf: [Timeline] = []
            for timeline in timelines {
                if let timelineDictionary = timeline as? NSDictionary {
                    timelinesBuf += [Timeline(dictionary: timelineDictionary)]
                }
            }
            
            self.timelines = timelinesBuf
            
            self.tableView.reloadData()
        }, failure: { (error: NSError?) -> Void in
            println("ERROR: \(error)")
            return
        })
    }
    
    
    // MARK: - TableView data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timelines.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MainCell", forIndexPath: indexPath) as! HomeViewTableCell
        
        cell.timeline = timelines[indexPath.row]
        
        return cell
    }
    
    // MARK: - TableView delegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.frame.size.width + 37 + 60
    }
}


class HomeViewTableCell: UITableViewCell {
    
    var timeline: Timeline? {
        didSet {
            if let unwrappedTimeline = timeline {
                animatedImageURL = unwrappedTimeline.gifURL
                nameLabel.text = unwrappedTimeline.userName
            }
        }
    }
    
    private var animatedImageURL: NSURL? {
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
        animatedImageView.contentMode = .ScaleAspectFill
    }
    
    
    @IBAction func didTouchLikeButton(sender: AnyObject) {
        println("like")
    }
    
    
    @IBAction func didTouchCommentButton(sender: AnyObject) {
        println("comment")
    }
}



class Timeline {
    var gifURL: NSURL
    var likeNum: Int
    var title: String?
    var description: String?
    var userName: String?
    
    init(dictionary: NSDictionary) {
        gifURL = NSURL(string: dictionary["pic"]! as! String)!
        likeNum = dictionary["like_num"]!.integerValue
        title = dictionary["title"] as? String
        description = dictionary["description"] as? String
        userName = dictionary["user_name"] as? String
    }
}