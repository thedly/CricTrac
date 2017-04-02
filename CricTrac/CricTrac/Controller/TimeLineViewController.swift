
//
//  TimeLineViewController.swift
//  CricTrac
//
//  Created by Renjith on 9/16/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import SwiftyJSON
import GoogleMobileAds
import KRProgressHUD
import Kingfisher

class TimeLineViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ThemeChangeable,PostSendable,Deletable,Refreshable{
    
    @IBOutlet weak var timeLineTable: UITableView!
    
    var currentTheme:CTTheme!
    
    var newPostText:UITextField?
    
    var timelineDS = [[String:String]]()
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    let  refreshControl = UIRefreshControl()
    var totalPosts = 5
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarProperties();
        currentTheme = cricTracTheme.currentTheme
        setBackgroundColor()
        self.automaticallyAdjustsScrollViewInsets = false
        
        timeLineTable.rowHeight = UITableViewAutomaticDimension;
        timeLineTable.estimatedRowHeight = 50.0;
        
        //setUIBackgroundTheme(view)
        
        loadTimeline()
        getAllUserProfileInfo(){}
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
        
        //loadBannerAds()
    }
    
    //MARK: Ads related
    
    func loadBannerAds() {
        
        bannerView.adUnitID = adUnitId
        bannerView.rootViewController = self
        bannerView.loadRequest(GADRequest())
    }
    
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
       // navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    
    func refresh(sender:AnyObject) {
        loadTimeline()
    }
    
    func addObserverToTimeline(){
        
        
    }
    
    func sendNewPost(text:String){
        
        addNewPost(text) { data in
            
            var timeLineData:[JSON]!
            
            if let  value = timelineData?.arrayValue{
                
                timeLineData = value
            }else{
                
                timeLineData = [JSON]()
            }
            
            
            timeLineData.insert(JSON(data["timeline"]!), atIndex: 0)
            
            
            timelineData = JSON(timeLineData)
            
            dispatch_async(dispatch_get_main_queue(),{
                
                self.timeLineTable.reloadData()
            })
        }
    }
    
    func modifyPost(text: String, postId: String,index:Int) {

        editPost(text,postId: postId) { (data) in
            
            var timeLineData:[JSON]!
            
            if let  value = timelineData?.arrayValue{
                
                timeLineData = value
            }else{
                
                timeLineData = [JSON]()
            }
            
            
            timeLineData[index] = JSON(data["timeline"]!)
            
            
            timelineData = JSON(timeLineData)
            
            dispatch_async(dispatch_get_main_queue(),{
                
                self.timeLineTable.reloadData()
                KRProgressHUD.dismiss()
            })
            
        }
    }
    
    
    
    func loadTimeline(){
        
        getLatestTimelines({ (result) in
            
            timelineData = result.dictionaryValue["timeline"]
            if let key = result.dictionaryValue["pageKey"]?.stringValue{
                
                pageKey = key
                
                LoadTimeline(key, sucess: { (data) in
                    
                    pageKey = data.dictionaryValue["pageKey"]?.stringValue
                    
                    
                    if let timelineArrayObj = timelineData?.arrayObject, let dictionaryTimelineObj = data.dictionaryValue["timeline"], let dictionaryTimelineArrayObj = dictionaryTimelineObj.arrayObject {
                        
                        timelineData = JSON(timelineArrayObj + dictionaryTimelineArrayObj)
                    }
                    
                    
                    
                    }, failure: { (error) in
                        
                        dispatch_async(dispatch_get_main_queue(),{
                            
                            self.refreshControl.endRefreshing()
                        })
                })
            }
            
            dispatch_async(dispatch_get_main_queue(),{
                
                self.refreshControl.endRefreshing()
                
                self.timeLineTable.reloadData()
            })
            
        }) { (error) in }
        
        dispatch_async(dispatch_get_main_queue(),{
            
            self.refreshControl.endRefreshing()
        })
    }
    
    func didMenuButtonTapp(){
        sliderMenu.setDrawerState(.Opened, animated: true)
    }
    
    func didNewMatchButtonTapp(){
        let newMatchVc = viewControllerFrom("Main", vcid: "AddMatchDetailsViewController")
        let nav = UINavigationController(rootViewController: newMatchVc)
        sliderMenu.mainViewController = nav
       // self.presentViewController(nav, animated: true) {}
    }
    
    func setNavigationBarProperties(){
        
        currentTheme = cricTracTheme.currentTheme
        
        let menuButton: UIButton = UIButton(type:.Custom)
        menuButton.setImage(UIImage(named: "menu-icon"), forState: UIControlState.Normal)
        menuButton.addTarget(self, action: #selector(didMenuButtonTapp), forControlEvents: UIControlEvents.TouchUpInside)
        menuButton.frame = CGRectMake(0, 0, 40, 40)
        let leftbarButton = UIBarButtonItem(customView: menuButton)
        
        
        let addNewMatchButton: UIButton = UIButton(type:.Custom)
        addNewMatchButton.frame = CGRectMake(0, 0, 40, 40)
        addNewMatchButton.setTitle("+", forState:.Normal)
        addNewMatchButton.titleLabel?.font = UIFont(name: appFont_bold, size: 30)
        addNewMatchButton.addTarget(self, action: #selector(didNewMatchButtonTapp), forControlEvents: UIControlEvents.TouchUpInside)
        let righttbarButton = UIBarButtonItem(customView: addNewMatchButton)
        
        //assign button to navigationbar
        
        navigationItem.leftBarButtonItem = leftbarButton
        navigationItem.rightBarButtonItem = righttbarButton
        navigationController!.navigationBar.barTintColor = currentTheme.topColor //UIColor(hex: topColor)
        title = "TIMELINE"
       // let titleDict: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.whiteColor()]
       // navigationController!.navigationBar.titleTextAttributes = titleDict
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
            acell =  cell
            acell.contentView.frame = CGRectMake(acell.contentView.frame.minX, acell.contentView.frame.minY, acell.contentView.frame.width, 200)
        }
        else{
            
            let data = timelineData!.arrayValue[indexPath.section-1]
            
            if let imageurl = data.dictionaryValue["postImage"]?.string {
                
                let imageCell =  timeLineTable.dequeueReusableCellWithIdentifier("imagepost", forIndexPath: indexPath) as! ImagePostTableViewCell
                let postid = data.dictionaryValue["postId"]?.stringValue
                imageCell.imagePost.image = nil
                imageCell.imagePost.loadImage(imageurl, postId:postid!)
                
                acell = imageCell
                
            }
            else{
                
                let  postCell =  timeLineTable.dequeueReusableCellWithIdentifier("aPost", forIndexPath: indexPath) as! APostTableViewCell
                
                postCell.parent = self
                postCell.postIndex = indexPath.section-1
                
                let friendId = data["OwnerID"].stringValue
                
                if let dateTimeStamp = data["AddedTime"].double{
    
                    let date = NSDate(timeIntervalSince1970:dateTimeStamp/1000.0)
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.timeZone = NSTimeZone.localTimeZone()
                    dateFormatter.timeStyle = .ShortStyle
                    dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                    postCell.postedDate.text = dateFormatter.stringFromDate(date)
                }
                
                postCell.postOwnerId = friendId
                
                 let postedBy = data["PostedBy"].stringValue
                if postedBy == "CricTrac"{
                    postCell.postOwnerName.text = "CricTrac"
                    postCell.deleteButton.hidden = true
                    
                    postCell.postOwnerCity.text = data["PostType"].stringValue
                    
                }else{
                    postCell.postOwnerName.text = data.dictionaryValue["OwnerName"]?.stringValue ?? "No Name"
                    if let postedBy = data["OwnerID"].string  where postedBy == currentUser!.uid{
                        
                        postCell.deleteButton.hidden = false
                        
                    }else{
                        postCell.deleteButton.hidden = true
                    }
                    
                    fetchFriendCity(friendId, sucess: { (data) in
                        
                        friendsCity[friendId] = data
                        dispatch_async(dispatch_get_main_queue(),{
                            
                            postCell.postOwnerCity.text = data
                            
                        })
                        
                    })
                    fetchFriendDetail(friendId, sucess: { (result) in
                        let proPic = result["proPic"]
                        let city =   result["city"]
                        postCell.postOwnerCity.text = city
                        if proPic! == "-"{
                            let imageName = "propic.png"
                            let image = UIImage(named: imageName)
                            postCell.postOwnerPic.image = image
                        }else{
                            if let imageURL = NSURL(string:proPic!){
                                postCell.postOwnerPic.kf_setImageWithURL(imageURL)
                            }
                        }
                        
                    })
                    
                }
                
               
                postCell.totalLikeCount = 0
                postCell.post.text = data.dictionaryValue["Post"]?.stringValue
                postCell.index = indexPath.section-1
                var commentsCount = 0
                
                if let value = data.dictionaryValue["TimelineComments"]?.count{
                    
                    commentsCount = value
                }
                
                postCell.commentCount.setTitle("\(commentsCount) Comments", forState: .Normal)
                
                
                postCell.postId = data.dictionaryValue["postId"]?.stringValue
                
                var likesCount = 0
                
                var likeColor = UIColor.grayColor()
                
                if let likes = data.dictionaryValue["Likes"]?.dictionaryObject as? [String:[String:String]]{
                    
                    let result = likes.filter{ return  $0.1["OwnerID"] == currentUser!.uid }
                    if result.count > 0 {
                        likeColor = UIColor.yellowColor()
                    }
                    likesCount = likes.count
                    
                    postCell.totalLikeCount = likesCount
                    
                }
                
                postCell.likeCount.setTitle("\(likesCount) Likes", forState: .Normal)
                postCell.likeButton.titleLabel?.textColor = likeColor
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
    
   
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section  == 0{
            let newPost = viewControllerFrom("Main", vcid: "NewPostViewController") as! NewPostViewController
            newPost.sendPostDelegate = self
            newPost.modalPresentationStyle = .OverCurrentContext
            presentViewController(newPost, animated: true, completion: nil)
        }
        else{
            
            let newPost = viewControllerFrom("Main", vcid: "CommentsViewController") as! CommentsViewController
            newPost.postData =  timelineData!.arrayValue[indexPath.section-1]
            newPost.postIndex = indexPath.section-1
            newPost.refreshableParent = self
            presentViewController(newPost, animated: true, completion: nil)
            
        }
    }
    
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
        {
            timeLineTable.reloadData()
            
            if let key = pageKey{
                
                LoadTimeline(key, sucess: { (data) in
                    
                    pageKey = data.dictionaryValue["pageKey"]?.stringValue
                    
                    timelineData = JSON(timelineData!.arrayObject! + data.dictionaryValue["timeline"]!.arrayObject!)
                    
                    }, failure: { (error) in
                        
                        
                })  
            }
        }
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
    
    func deletePost(index:Int){
        timelineData!.arrayObject?.removeAtIndex(index)
        timeLineTable.reloadData()
    }
    
    @IBAction func exit(sender: UIButton) {
        
        dismissViewControllerAnimated(true) {
            
        }
    }
    
    
    func refresh(){
        timeLineTable.reloadData()
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
