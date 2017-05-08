//
//  CommentsViewController.swift
//  CricTrac
//
//  Created by Renjith on 25/12/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import SwiftyJSON

class CommentsViewController: UIViewController,ThemeChangeable,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIActionSheetDelegate,DeleteComment{
    
    @IBOutlet weak var contentViewForCommentCell: UIView!
    @IBOutlet weak var postComment: UIButton!
    @IBOutlet weak var commentBox: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inerView: UIView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var barView: UIView!
    
//    var postIndex = 0
//    var postLikeCount = 0
    var initialLikes = 0
    var refreshableParent:Refreshable?
    var dataSource = [[String:AnyObject]]()
    
    var postDataNew = [String:AnyObject]()
    
    var postId:String = ""
    var comntsHeightConstraint = false
    //var postData:JSON?
    var currentTheme:CTTheme!
    var commentId:String = ""
    //var postOwnerId:String?
    var parent:Deletable?
    //var ownerCity:String = ""
    var commentDate:String = ""
    
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //postOwnerName.text = "Arjun"
        //addTapGestureToUserName()
       
        setNavigationBarProperties();
        currentTheme = cricTracTheme.currentTheme
        setBackgroundColor()
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clearColor()
        tableView.backgroundView?.backgroundColor = UIColor.clearColor()
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 50.0;
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.darkGrayColor().CGColor
        commentTextView.setPlaceHolder()
        
         tableView.registerNib(UINib.init(nibName:"CPostTableViewCell", bundle: nil), forCellReuseIdentifier: "cPost")
        
     //   postComment.enabled = false
    //  postComment.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
      
        //postId = (postData!.dictionaryValue["postId"]?.stringValue)!
        //postText.text = postData!.dictionaryValue["Post"]?.stringValue
        //userName.text = postData!.dictionaryValue["OwnerName"]?.stringValue ?? "No Name"
        
        //sajith-  fetch the fresh post data
//        getPost(postId) { (data) in
//            if !data .isEmpty {
//                self.postOwnerId = data["OwnerID"] as? String
//                self.postText.text = data["Post"] as? String
//            
//                let postedBy = data["PostedBy"] as? String
//                if postedBy == "CricTrac" {
//                    self.postOwnerName.text = "CricTrac"
//                }
//                else{
//                    self.postOwnerName.text = data ["OwnerName"] as? String
//                }
//            
//                if let postDateTS = data["AddedTime"] as? Double{
//                    let date = NSDate(timeIntervalSince1970:postDateTS/1000.0)
//                    let dateFormatter = NSDateFormatter()
//                    dateFormatter.timeZone = NSTimeZone.localTimeZone()
//                    dateFormatter.timeStyle = .ShortStyle
//                    dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
//                    self.date.text = dateFormatter.stringFromDate(date)
//                }
//            
//                var likeColor = UIColor.redColor()
//                let childLikes = data["Likes"] as? [String : AnyObject]
//                if childLikes != nil {
//                    for (key, value) in childLikes! {
//                        if currentUser!.uid == value["OwnerID"] as? String {
//                            likeColor = UIColor.greenColor()
//                        }
//                    }
//                }
//                self.likeButton.titleLabel?.textColor = likeColor
//    
//                if (data["LikeCount"] != nil) {
//                    let likeCount = data["LikeCount"] as? Int
//                    self.likes.text = "\(likeCount!) Likes"
//                }
//                else {
//                    self.likes.text = "0 Likes"
//                }
//            
//                if (data["CommentCount"] != nil) {
//                    let cmtCount = data["CommentCount"] as? Int
//                    self.comments.text = "\(cmtCount!) Comments"
//                }
//                else {
//                    self.comments.text = "0 Comments"
//                }
//                //}
//        
////              if let likeCount = postData!.dictionaryValue["Likes"]?.count{
////              likes.text = "\(likeCount) Likes"
////              postLikeCount = likeCount
////              initialLikes = postLikeCount
////              }else
////              {
////              likes.text = "0 Likes"
////              }
//        
////              if let commentCount = postData!.dictionaryValue["TimelineComments"]?.count{
////              comments.text = "\(commentCount) Comments"
////              }else
////              {
////              comments.text = "0 Comments"
////              }
//        
//                let friendId = data["OwnerID"]!
//                if let city = friendsCity[friendId as! String]{
//                    self.userCity.text = city
//                }else
//                {
//                    fetchFriendCity(friendId as! String, sucess: { (city) in
//                        friendsCity[friendId as! String] = city
//                        dispatch_async(dispatch_get_main_queue(),{
//                            //self.userCity.text = city
//                        })
//                    })
//                }
//        
//                fetchFriendDetail(friendId as! String, sucess: { (result) in
//                    let proPic = result["proPic"]
//                    if proPic! == "-"{
//                        let imageName = defaultProfileImage
//                        let image = UIImage(named: imageName)
//                        self.profileImage.image = image
//                    }else
//                    {
//                        if let imageURL = NSURL(string:proPic!){
//                            self.profileImage.kf_setImageWithURL(imageURL)
//                        }
//                    }
//                    //sucess(result: ["proPic":proPic,"city":city])
//                })
//                
//        
////          var likeColor = UIColor.grayColor()
////        
////          if let likes = postData!.dictionaryValue["Likes"]?.dictionaryObject as? [String:    [String:String]]{
////          let result = likes.filter{ return  $0.1["OwnerID"] == currentUser!.uid }
////            if result.count > 0 {
////                likeColor = UIColor.whiteColor()
////            }
////            //likesCount = likes.count
////            //postCell.totalLikeCount = likesCount
////        }
////        
////        //postCell.likeCount.setTitle("\(likesCount) Likes", forState: .Normal)
////        likeButton.titleLabel?.textColor = likeColor
//        
//    
////        if let dateTimeStamp = postData!["AddedTime"].double{
////            let date = NSDate(timeIntervalSince1970:dateTimeStamp/1000.0)
////            let dateFormatter = NSDateFormatter()
////            dateFormatter.timeZone = NSTimeZone.localTimeZone()
////            dateFormatter.timeStyle = .ShortStyle
////            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
////            self.date.text = dateFormatter.stringFromDate(date)
////        }
//        
//                getAllComments(self.postId) { (data) in
//                    self.dataSource = data
//                    self.tableView.reloadData()
//                }
//            }
//            else {
//                let alert = UIAlertController(title: "", message: "Post not found", preferredStyle: UIAlertControllerStyle.Alert)                
//                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!)-> Void in
//                    //print("delete")
//                    //delete the nottification
//                }))
//                //self.dismissViewControllerAnimated(true) {}
//                //return
//            }
//        }
        
        getPost(postId) { (data) in
            self.postDataNew = data
            self.tableView.reloadData()
        }
        
        getAllComments(self.postId) { (data) in
            self.dataSource = data
            self.tableView.reloadData()
        }
        
        //dataSource.sort({$0.dataSource["AddedTime"].compare($1.AddedTime) == .OrderedAscending})
        
    }
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
      // navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    func setNavigationBarProperties(){
        var currentTheme:CTTheme!
        currentTheme = cricTracTheme.currentTheme
        self.barView.backgroundColor = currentTheme.topColor
      //  navigationController!.navigationBar.barTintColor = currentTheme.topColor //UIColor(hex: topColor)
        self.contentViewForCommentCell.backgroundColor =  currentTheme.topColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 2
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return dataSource.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
       // let aCell = UITableViewCell()
        let aCell =  tableView.dequeueReusableCellWithIdentifier("commentcell", forIndexPath: indexPath) as! CommentTableViewCell
        
        let cCell =  tableView.dequeueReusableCellWithIdentifier("cPost", forIndexPath: indexPath) as! CPostTableViewCell
        
        if !postDataNew .isEmpty  {
            //display the post in the first row of the tableview
            if indexPath.row == 0  {
                let data = postDataNew
                cCell.postOwnerId = data["OwnerID"] as? String
                let postedBy = data["PostedBy"] as? String
                cCell.postId = postId as? String
               
                if postedBy == "CricTrac" {
                    cCell.postOwnerName.text = "CricTrac"
                }
                else{
                    cCell.postOwnerName.text = data ["OwnerName"] as? String
                }
                
                //display post owners image
                if ((data["OwnerID"]) != nil) {
                    fetchFriendDetail((data["OwnerID"]  as? String)!, sucess: { (result) in
                        let proPic = result["proPic"]
                            
                        //aCell.profileImage.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                        cCell.profileImage.layer.borderWidth = 1
                        cCell.profileImage.layer.masksToBounds = false
                        cCell.profileImage.layer.borderColor = UIColor.clearColor().CGColor
                        cCell.profileImage.layer.cornerRadius = cCell.profileImage.frame.width/2
                        cCell.profileImage.clipsToBounds = true
                            
                        if proPic! == "-"{
                            let imageName = defaultProfileImage
                            let image = UIImage(named: imageName)
                            cCell.profileImage.image = image
                        }
                        else{
                            if let imageURL = NSURL(string:proPic!){
                                cCell.profileImage.kf_setImageWithURL(imageURL)
                            }
                        }
                    })
                }
                
                let friendId = data["OwnerID"]!
                if let city = friendsCity[friendId as! String]{
                    cCell.ownerCity.text = city
                }
                else {
                    fetchFriendCity(friendId as! String, sucess: { (city) in
                        friendsCity[friendId as! String] = city
                        dispatch_async(dispatch_get_main_queue(),{
                            cCell.ownerCity.text = city
                        })
                    })
                }
                
                if let postDateTS = data["AddedTime"] as? Double{
                    let date = NSDate(timeIntervalSince1970:postDateTS/1000.0)
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.timeZone = NSTimeZone.localTimeZone()
                    dateFormatter.timeStyle = .ShortStyle
                    dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                    cCell.date.text = dateFormatter.stringFromDate(date)
                }
                
                cCell.postText.text = data["Post"] as? String
                cCell.delCommentBtn.hidden = true
                
//                cCell.likeButton.frame = CGRectMake(0, 0, 10, 10)
//                cCell.likeButton.setImage(UIImage(named: "Like-100"), forState: UIControlState.Normal)
//                cCell.likeButton.titleLabel?.textColor = UIColor.blackColor()
                
//                let childLikes = data["Likes"] as? [String : AnyObject]
//                if childLikes != nil {
//                    for (key, value) in childLikes! {
//                        if currentUser!.uid == value["OwnerID"] as? String {
//                            cCell.likeButton.titleLabel?.textColor = UIColor.whiteColor()
//                            cCell.likeButton.setImage(UIImage(named: "Like-Filled"), forState: UIControlState.Normal)
//                        }
//                    }
//                }
                
                var likeColor = UIColor.blackColor()
                cCell.likeButton.setImage(UIImage(named: "Like-100"), forState: UIControlState.Normal)
                
                if data["isSelfLiked"] as? String == "1" {
                    likeColor = UIColor.whiteColor()
                    cCell.likeButton.setImage(UIImage(named: "Like-Filled"), forState: UIControlState.Normal)
                }
                cCell.likeButton.titleLabel?.textColor = likeColor
                
                
                if (data["LikeCount"] != nil) {
                    let likeCount = data["LikeCount"] as? Int
                    cCell.likes.setTitle("\(likeCount!) Likes", forState:  .Normal)
                }
                else {
                    cCell.likes.setTitle("0 Likes", forState: .Normal)
                }
                
                if (data["CommentCount"] != nil) {
                    let cmtCount = data["CommentCount"] as? Int
                    cCell.comments.setTitle("\(cmtCount!) Comments", forState: .Normal)
                }
                else {
                    cCell.comments.setTitle("0 Comments", forState: .Normal)
                }
                
                cCell.selectionStyle = UITableViewCellSelectionStyle.None
                cCell.backgroundColor = UIColor.clearColor()
                return cCell
            }
            else {
                //display the comments
                let data = dataSource[indexPath.row - 1]
                
                aCell.ownerId = data["OwnerID"] as? String

                if let val = data["Comment"] as? String{
                    aCell.commentID = data["commentId"] as? String
                    aCell.postID = postId as? String
                    aCell.commentText.text = val
                    aCell.backgroundColor = UIColor.clearColor()
                }
            
                if let dateTimeStamp = data["AddedTime"] as? Double{
                    let date = NSDate(timeIntervalSince1970:dateTimeStamp/1000.0)
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.timeZone = NSTimeZone.localTimeZone()
                    dateFormatter.timeStyle = .ShortStyle
                    dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                    aCell.commentDate.text = dateFormatter.stringFromDate(date)
                }
            
                if var value = data["OwnerName"] as? String{
                    if value == ""{
                        value = "No Name"
                    }
                    aCell.userName.text =   value
                }
            
                if currentUser?.uid == data["OwnerID"]  as? String {
                    aCell.delCommentBtn.hidden = false
                }
                else {
                    aCell.delCommentBtn.hidden = true
                }
            
                //display comment owners image
                if ((data["OwnerID"]) != nil) {
                    fetchFriendDetail((data["OwnerID"]  as? String)!, sucess: { (result) in
                        let proPic = result["proPic"]
                
                        aCell.userImage.layer.borderWidth = 1
                        aCell.userImage.layer.masksToBounds = false
                        aCell.userImage.layer.borderColor = UIColor.clearColor().CGColor
                        aCell.userImage.layer.cornerRadius = aCell.userImage.frame.width/2
                        aCell.userImage.clipsToBounds = true
                
                        if proPic! == "-"{
                            let imageName = defaultProfileImage
                            let image = UIImage(named: imageName)
                            aCell.userImage.image = image
                        }
                        else{
                            if let imageURL = NSURL(string:proPic!){
                                aCell.userImage.kf_setImageWithURL(imageURL)
                            }
                        }
                    })
                }
            }
        }
        
        aCell.selectionStyle = UITableViewCellSelectionStyle.None
        aCell.backgroundColor = UIColor.clearColor()
        return aCell
    }
    
    func textViewDidBeginEditing(textView: UITextView){
        textView.text = ""
    }
    
    func textViewDidEndEditing(textView: UITextView){
        if textView == commentTextView{
            commentTextView.setPlaceHolder()
            textViewHeightConstraint.constant = 30
        }
    }
    
    @IBAction func postNewComment(sender: AnyObject) {
        // network reachability test
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if !appDelegate.reachability.isReachable()  {
            let alert = UIAlertController(title: "", message: networkErrorMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        let text = commentTextView.text.trimWhiteSpace
        if text.characters.count > 0 && text != "Enter your comment" {
            commentTextView.resignFirstResponder()
            commentTextView.setPlaceHolder()
            textViewHeightConstraint.constant = 30
            dataSource.append(["OwnerName":loggedInUserName ?? "Another Friend","Comment":text])
            //let postId = postData!.dictionaryValue["postId"]?.stringValue
            addNewComment(postId, comment:text)
        
            tableView.reloadData()
        }
    }
    
    
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//    
//    }
//    
//    func deleteTapp() {
//
//    }
    
    func deletebuttonTapped() {
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool{
        let textViewContent = textView.text
        /*
         
         if textViewContent != ""{
         
         let lastChar = textViewContent[textViewContent.endIndex.predecessor()]
         if lastChar == "\n" && text ==  ""{
         if self.TextViewHeight.constant > 30{
         self.TextViewHeight.constant = self.TextViewHeight.constant-18
         }
         }
         }
         if text ==  "\n"{
         
         UIView.animateWithDuration(0.1, animations: { () -> Void in
         if self.TextViewHeight.constant < 102{
         self.TextViewHeight.constant = self.TextViewHeight.constant+18
         }
         
         })
         }
         */
        
        //if text ==  "\n"{ return false}
       
        
//        if textViewContent.characters.count < 0 {
//            postComment.enabled = false
//            postComment.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
//
//        }
//        else {
//            postComment.enabled = true
//            postComment.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
//        
//        }
       
   
//        let lines  =  textViewContent.characters.count/40
//        let heightConstant = Int((self.textViewHeightConstraint.constant - 30)/18)
//        
//        if lines > heightConstant{
//            if self.textViewHeightConstraint.constant < 102{
//                UIView.animateWithDuration(0.1, animations: { () -> Void in
//                    self.textViewHeightConstraint.constant = self.textViewHeightConstraint.constant+18
//                })}
//        }else if heightConstant > lines
//        {
//            self.textViewHeightConstraint.constant = self.textViewHeightConstraint.constant - 18
//        }
        
        
        //sajith - increase the height of the text box and view
        self.contentViewForCommentCell.frame = CGRect(x: 0, y: 0, width: 350, height: 120)
        self.contentViewForCommentCell.layoutIfNeeded()
        
        let contentSize = textView.sizeThatFits(textView.bounds.size)
        var frame = textView.frame
        frame.size.height = contentSize.height
        textView.frame = frame
        
        return true
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool{
        textView.clearPlaceHolder()
        return true
    }
    
    @IBAction func didTapClose(sender: AnyObject) {
        dismissViewControllerAnimated(true) {
//            if self.postLikeCount < self.initialLikes{
//                var likes = timelineData!.arrayObject![self.postIndex]["Likes"] as! [String:[String:String]]
//                let keys =  likes.filter{key,val in
//                    return val["OwnerID"]! == currentUser!.uid
//                    }.map{
//                        return $0.0
//                }
//
//                if keys.count > 0 {
//                    likes.removeValueForKey(keys[0])
//                    timelineData![self.postIndex]["Likes"] = JSON(likes)
//                }
//            }
//            if self.postLikeCount != self.initialLikes{
//                self.refreshableParent?.refresh()
//            }
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
