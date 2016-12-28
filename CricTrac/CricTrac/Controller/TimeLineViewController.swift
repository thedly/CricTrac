//
//  TimeLineViewController.swift
//  CricTrac
//
//  Created by Renjith on 9/16/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import SwiftyJSON

class TimeLineViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ThemeChangeable,PostSendable{
    
    @IBOutlet weak var timeLineTable: UITableView!
    
    var currentTheme:CTTheme!
    
    var newPostText:UITextField?
    
    var timelineDS = [[String:String]]()
    
    let  refreshControl = UIRefreshControl()
    var totalPosts = 5
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        
        //setUIBackgroundTheme(view)
        
        loadTimeline()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Loading New Posts")
        refreshControl.addTarget(self, action: #selector(TimeLineViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        timeLineTable.addSubview(refreshControl)
        
        
        timeLineTable.registerNib(UINib.init(nibName:"AddPostTableViewCell", bundle: nil), forCellReuseIdentifier: "addpost")
        
        timeLineTable.registerNib(UINib.init(nibName:"ImagePostTableViewCell", bundle: nil), forCellReuseIdentifier: "imagepost")
        
        //
        
        timeLineTable.registerNib(UINib.init(nibName:"APostTableViewCell", bundle: nil), forCellReuseIdentifier: "aPost")
        
        if !directoryExistsInsideDocuments("cachedImages"){
            
            createDirectoryInsideDocuments("cachedImages")
            
        }
        
        //loadAllNewPosts()
        
        // Do any additional setup after loading the view.
    }
    
    
    func changeThemeSettigs(){
        currentTheme = cricTracTheme.currentTheme
        timeLineTable.backgroundView?.backgroundColor = UIColor.clearColor()
        timeLineTable.backgroundColor = UIColor.clearColor()
        timeLineTable.reloadData()
    }
    
    
    func refresh(sender:AnyObject) {
        
    }
    
    func addObserverToTimeline(){
        
        
    }
    
    func sendNewPost(text:String){
        
        addNewPost(text) { data in
            
            
            
            var timelineDta = timelineData!.dictionaryValue["timeline"]!.arrayObject
            
            let pageKey = timelineData!.dictionaryValue["pageKey"]!.stringValue as AnyObject
            
            timelineDta?.insert(data["timeline"]!, atIndex: 0)
            
            let newResultDict:[String:AnyObject] = ["timeline":timelineDta!,"pageKey":pageKey]
            
            timelineData = JSON(newResultDict)
            
            self.timeLineTable.reloadData()
            
        }
    }
    
    func loadTimeline(){
        
        getLatestTimelines({ (result) in
            
            timelineData = result
            self.timeLineTable.reloadData()
            
        }) { (error) in }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        var acell = UITableViewCell()
        
        if indexPath.section == 0{
            let cell = timeLineTable.dequeueReusableCellWithIdentifier("addpost", forIndexPath: indexPath) as! AddPostTableViewCell
            // cell.newPostButton.addTarget(self, action: #selector(addPost) , forControlEvents: .TouchUpInside)
            //newPostText = cell.newPostText
            acell =  cell
        }
        else{
            
            
            
            let data = timelineData!.dictionaryValue["timeline"]!.arrayValue[indexPath.section-1]
            
            
            if let imageurl = data.dictionaryValue["postImage"]?.string {
                
                let imageCell =  timeLineTable.dequeueReusableCellWithIdentifier("imagepost", forIndexPath: indexPath) as! ImagePostTableViewCell
                let postid = data.dictionaryValue["postId"]?.stringValue
                imageCell.imagePost.image = nil
                imageCell.imagePost.loadImage(imageurl, postId:postid!)
                
                acell = imageCell
                
            }
            else{
                
                let  postCell =  timeLineTable.dequeueReusableCellWithIdentifier("aPost", forIndexPath: indexPath) as! APostTableViewCell
                
                postCell.post.text = data.dictionaryValue["Post"]?.stringValue
                acell = postCell
                
            }
            
        }
        
        acell.contentView.backgroundColor = currentTheme.boxColor
        acell.backgroundColor = UIColor.clearColor()
        acell.selectionStyle = .None
        return acell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        
        if timelineData == nil{
            return 1
        }
        
        return timelineData!.count+1
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{return 125}
        return 225
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section  == 0{
            let newPost = viewControllerFrom("Main", vcid: "NewPostViewController") as! NewPostViewController
            newPost.sendPostDelegate = self
            newPost.modalPresentationStyle = .OverCurrentContext
            presentViewController(newPost, animated: true, completion: nil)
        }
        else{
            
            let newPost = viewControllerFrom("Main", vcid: "CommentsViewController") as! CommentsViewController
            newPost.postData =  timelineData!.dictionaryValue["timeline"]!.arrayValue[indexPath.section-1]
            presentViewController(newPost, animated: true, completion: nil)
            
        }
    }
    
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
        //            {
        //
        //
        //                timeLineTable.reloadData()
        //
        //                loadTimelineFromId({ (timeline,postId) in
        //
        //                    var timeLineDic = timeline as! [String : String]
        //                    timeLineDic["postId"] = postId
        //                    self.timelineDS.append(timeLineDic )
        //
        //                })
        //
        //                }
    }
    
    
    
    //    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //
    //        return 15
    //    }
    
    //    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //
    //        let aView = UIView(frame: CGRectMake(0, 0, view.frame.width, 10) )
    //        aView.backgroundColor = UIColor.clearColor()
    //
    //        return aView
    //    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let aView = UIView(frame: CGRectMake(0, 0, view.frame.width, 20) )
        aView.backgroundColor = UIColor.clearColor()
        
        return aView
    }
    
    @IBAction func exit(sender: UIButton) {
        
        dismissViewControllerAnimated(true) {
            
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
