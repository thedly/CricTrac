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
    @IBOutlet weak var scrollView: UIScrollView!
    
    var postIndex = 0
    var commentCount = 0
    var totalLikesCount = 0
    var refreshableParent:Refreshable?
    var dataSource = [[String:AnyObject]]()
    
    var postDataNew = [String:AnyObject]()
    
    var postId:String = ""
    var comntsHeightConstraint = false
    var currentTheme:CTTheme!
    var commentId:String = ""
    var parent:Deletable?
    var commentDate:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
      // hideKeyboardWhenTappedAround()
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
        
        getPost(postId) { (postData) in
            self.postDataNew = postData
            self.tableView.reloadData()
        }
        
        getAllComments(self.postId) { (commentData) in
            self.dataSource = commentData
            self.tableView.reloadData()
        }
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
    
//    func hideKeyboardWhenTappedAround() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
//        
//        tap.cancelsTouchesInView = false
//        
//      // view.addGestureRecognizer(tap)
//        self.scrollView.addGestureRecognizer(tap)
//        [self.view .addSubview(scrollView)]
//    }
//    
//    func dismissKeyboard() {
//      
//       // self.resignFirstResponder()
//       
//        self.scrollView.endEditing(true)
//       
//    }
   
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
        aCell.parent = self
        
        aCell.postIndex = postIndex
        
        let cCell =  tableView.dequeueReusableCellWithIdentifier("cPost", forIndexPath: indexPath) as! CPostTableViewCell
         cCell.parent = self
        
        cCell.postIndex = postIndex
        
        if !postDataNew .isEmpty {
            if postDataNew["isDeleted"]?.integerValue != 1 {
                //display the post in the first row of the tableview
                if indexPath.row == 0  {
                    let postData = postDataNew
                    cCell.postOwnerId = postData["OwnerID"] as? String
                    let postedBy = postData["PostedBy"] as? String
                    cCell.postId = postId as? String
                   
                    if postedBy == "CricTrac" {
                        cCell.postOwnerName.text = "CricTrac"
                        cCell.ownerCity.text = postData["PostType"] as? String
                    }
                    else{
                       // cCell.postOwnerName.text = postData ["OwnerName"] as? String
                        
                       if postData["OwnerID"] != nil {
                            let friendId = postData["OwnerID"]!
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
                        }
                    }
                    
                    //display post owners image
                    if ((postData["OwnerID"]) != nil) {
                        fetchBasicProfile((postData["OwnerID"]  as? String)!, sucess: { (result) in
                            let proPic = result["proPic"]
                            let name = "\(result["firstname"]!) \(result["lastname"]!)"
                             cCell.postOwnerName.text = name
                            
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
                    
                    if let postDateTS = postData["AddedTime"] as? Double{
                        let date = NSDate(timeIntervalSince1970:postDateTS/1000.0)
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.timeZone = NSTimeZone.localTimeZone()
                        dateFormatter.timeStyle = .ShortStyle
                        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                        cCell.date.text = dateFormatter.stringFromDate(date)
                    }
                    
                    cCell.postText.text = postData["Post"] as? String
                    cCell.delCommentBtn.hidden = true
                    cCell.likeButton.setImage(UIImage(named: "Like-100"), forState: UIControlState.Normal)
                    cCell.likeButton.titleLabel?.textColor = UIColor.blackColor()
                    
                    let childLikes = postData["Likes"] as? [String : AnyObject]
                    if childLikes != nil {
                        for (_, value) in childLikes! {
                            if currentUser!.uid == value["OwnerID"] as? String {
                                cCell.likeButton.titleLabel?.textColor = UIColor.whiteColor()
                                cCell.likeButton.setImage(UIImage(named: "Like-Filled"), forState: UIControlState.Normal)
                            }
                        }
                    }
                
                    if (postData["LikeCount"] != nil) {
                        let likeCount = postData["LikeCount"] as? Int
                        cCell.likes.setTitle("\(likeCount!) Likes", forState:  .Normal)
                        cCell.postLikeCount = likeCount!
                        self.totalLikesCount = likeCount!
                    }
                    else {
                        cCell.likes.setTitle("0 Likes", forState: .Normal)
                    }
                    
                    if (postData["CommentCount"] != nil) {
                        let cmtCount = postData["CommentCount"] as? Int
                        cCell.comments.setTitle("\(cmtCount!) Comments", forState: .Normal)
                        self.commentCount = cmtCount!
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
                    let commentData = dataSource[indexPath.row - 1]
                    
                    aCell.ownerId = commentData["OwnerID"] as? String

                    if let val = commentData["Comment"] as? String{
                        aCell.commentID = commentData["CommentID"] as? String
                        aCell.postID = postId as? String
                        aCell.commentText.text = val
                        aCell.backgroundColor = UIColor.clearColor()
                    }
                
                    if let dateTimeStamp = commentData["AddedTimeDisp"] as? Double{
                        let date = NSDate(timeIntervalSince1970:dateTimeStamp/1000.0)
                        let date2 = NSDate(timeIntervalSince1970:dateTimeStamp/1000.0)
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.timeZone = NSTimeZone.localTimeZone()
                        dateFormatter.timeStyle = .ShortStyle
                        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                        
                        let cmtDate = offsetFrom(date2)
                        if cmtDate == "" {
                            aCell.commentDate.text = dateFormatter.stringFromDate(date)
                        }
                        else {
                            aCell.commentDate.text = cmtDate
                        }
                    }
                
//                    if var value = commentData["OwnerName"] as? String{
//                        if value == ""{
//                            value = "No Name"
//                        }
//                        aCell.userName.text =   value
//                    }
                
                    if currentUser?.uid == commentData["OwnerID"] as? String || currentUser!.uid == postDataNew["OwnerID"]  as? String {
                        aCell.delCommentBtn.hidden = false
                    }
                    else {
                        aCell.delCommentBtn.hidden = true
                    }
                
                    //display comment owners image
                    if ((commentData["OwnerID"]) != nil) {
                        fetchBasicProfile((commentData["OwnerID"]  as? String)!, sucess: { (result) in
                            let proPic = result["proPic"]
                            let name = "\(result["firstname"]!) \(result["lastname"]!)"
                            aCell.userName.text = name
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
        }
        
        aCell.selectionStyle = UITableViewCellSelectionStyle.None
        aCell.backgroundColor = UIColor.clearColor()
        return aCell
    }
    

    
    func textViewDidEndEditing(textView: UITextView){
        if textView == commentTextView{
            //commentTextView.setPlaceHolder()
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
            contentViewHeightConstraint.constant = 50
            
            dataSource.append(["OwnerName":loggedInUserName ?? "Another Friend","Comment":text])
            //let postId = postData!.dictionaryValue["postId"]?.stringValue
            addNewComment(postId, comment:text)
        
            tableView.reloadData()
        }
    }
    
    func deletebuttonTapped() {

    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool{
        _ = textView.text
        
        let contentSize = textView.sizeThatFits(textView.bounds.size)
        var frame = textView.frame
        frame.size.height = contentSize.height
        
        if contentSize.height < 100 {
            textView.frame = frame
            contentViewHeightConstraint.constant = contentSize.height + 15
        }
        
        return true
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool{
        textView.clearPlaceHolder()
        return true
    }
    
    @IBAction func didTapClose(sender: AnyObject) {
        timelineData![self.postIndex]["CommentCount"] = JSON(self.commentCount)
        timelineData![self.postIndex]["LikeCount"] = JSON(self.totalLikesCount)

        dismissViewControllerAnimated(true) {
            
        }
    }
    
    func offsetFrom(date:NSDate) -> String {
        let now = NSDate()
        
        let dayHourMinuteSecond: NSCalendarUnit = [.Day, .Hour, .Minute, .Second]
        let difference = NSCalendar.currentCalendar().components(dayHourMinuteSecond, fromDate: date, toDate: now, options: [])
        
//        let seconds = "\(difference.second)s"
//        let minutes = "\(difference.minute)m" + " " + seconds
//        let hours = "\(difference.hour)h" + " " + minutes
//        let days = "\(difference.day)d" + " " + hours
        
        if difference.day == 1 {
            return "\(difference.day) day ago"
        }
        else if difference.day < 1 && difference.hour == 1 {
            return "\(difference.hour) hour ago"
        }
        else if difference.day < 1 && difference.hour > 1 && difference.hour < 24 {
            return "\(difference.hour) hours ago"
        }
        else if difference.day < 1 && difference.hour < 1 && difference.minute == 1 {
            return "\(difference.minute) minute ago"
        }
        else if difference.day < 1 && difference.hour < 1 && difference.minute > 1 && difference.minute < 60 {
            return "\(difference.minute) minutes ago"
        }
        else if difference.day < 1 && difference.hour < 1 && difference.minute < 1 && difference.second == 1 {
            return "\(difference.second) second ago"
        }
        else if difference.day < 1 && difference.hour < 1 && difference.minute < 1 && difference.second > 1 && difference.second < 60 {
            return "\(difference.second) seconds ago"
        }
        else {
            return ""
        }
        
//        if difference.day    > 0 { return days }
//        if difference.hour   > 0 { return hours }
//        if difference.minute > 0 { return minutes }
//        if difference.second > 0 { return seconds }
//        return ""
    }
    
}
