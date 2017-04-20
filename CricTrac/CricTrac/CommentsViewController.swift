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
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var userCity: UILabel!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var contentViewForCommentCell: UIView!
    @IBOutlet weak var postComment: UIButton!
    @IBOutlet weak var commentBox: UITextView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inerView: UIView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    var postIndex = 0
    var postLikeCount = 0
    var initialLikes = 0
    var refreshableParent:Refreshable?
    var dataSource = [[String:AnyObject]]()
    var postId:String = ""
    var comntsHeightConstraint = false
    //var postData:JSON?
    var currentTheme:CTTheme!
    var commentId:String = ""
   
//    override func viewWillAppear(animated: Bool) {
//        getAllComments(postId) { (data) in
//            self.dataSource = data
//            self.tableView.reloadData()
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setNavigationBarProperties();
        currentTheme = cricTracTheme.currentTheme
        setBackgroundColor()
        inerView.layer.masksToBounds = true
        inerView.layer.cornerRadius = inerView.frame.width/56
        inerView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clearColor()
        tableView.backgroundView?.backgroundColor = UIColor.clearColor()
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 50.0;
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.darkGrayColor().CGColor
        commentTextView.setPlaceHolder()
     //   postComment.enabled = false
    //  postComment.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
      
        //postId = (postData!.dictionaryValue["postId"]?.stringValue)!
        //postText.text = postData!.dictionaryValue["Post"]?.stringValue
        //userName.text = postData!.dictionaryValue["OwnerName"]?.stringValue ?? "No Name"
        
        //sajith-  fetch the fresh post data
        getPost(postId) { (data) in
            self.postText.text = data["Post"] as? String
            
            let postedBy = data["PostedBy"] as? String
            if postedBy == "CricTrac" {
                self.userName.text = "CricTrac"
            }
            else{
                self.userName.text = data ["OwnerName"] as? String
            }
            
            if let postDateTS = data["AddedTime"] as? Double{
                let date = NSDate(timeIntervalSince1970:postDateTS/1000.0)
                let dateFormatter = NSDateFormatter()
                dateFormatter.timeZone = NSTimeZone.localTimeZone()
                dateFormatter.timeStyle = .ShortStyle
                dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                self.date.text = dateFormatter.stringFromDate(date)
            }
            
            if (data["LikeCount"] != nil) {
                let likeCount = data["LikeCount"] as? Int
                self.likes.text = "\(likeCount!) Likes"
            }
            else {
                self.likes.text = "0 Likes"
            }
            if (data["CommentCount"] != nil) {
                let cmtCount = data["CommentCount"] as? Int
                self.comments.text = "\(cmtCount!) Comments"
            }
            else {
                self.comments.text = "0 Comments"
            }
        //}
        
//        if let likeCount = postData!.dictionaryValue["Likes"]?.count{
//            likes.text = "\(likeCount) Likes"
//            postLikeCount = likeCount
//            initialLikes = postLikeCount
//        }else
//        {
//            likes.text = "0 Likes"
//        }
        
//        if let commentCount = postData!.dictionaryValue["TimelineComments"]?.count{
//            comments.text = "\(commentCount) Comments"
//        }else
//        {
//            comments.text = "0 Comments"
//        }
        
        let friendId = data["OwnerID"]!
        if let city = friendsCity[friendId as! String]{
            self.userCity.text = city
        }else
        {
            fetchFriendCity(friendId as! String, sucess: { (city) in
                friendsCity[friendId as! String] = city
                dispatch_async(dispatch_get_main_queue(),{
                    //self.userCity.text = city
                })
            })
        }
        
        fetchFriendDetail(friendId as! String, sucess: { (result) in
            let proPic = result["proPic"]
            if proPic! == "-"{
                let imageName = "propic.png"
                let image = UIImage(named: imageName)
                self.profileImage.image = image
            }else
            {
                if let imageURL = NSURL(string:proPic!){
                    self.profileImage.kf_setImageWithURL(imageURL)
                }
            }
            //sucess(result: ["proPic":proPic,"city":city])
        })
    }
    
//        if let dateTimeStamp = postData!["AddedTime"].double{
//            let date = NSDate(timeIntervalSince1970:dateTimeStamp/1000.0)
//            let dateFormatter = NSDateFormatter()
//            dateFormatter.timeZone = NSTimeZone.localTimeZone()
//            dateFormatter.timeStyle = .ShortStyle
//            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
//            self.date.text = dateFormatter.stringFromDate(date)
//        }
        
        getAllComments(postId) { (data) in
            self.dataSource = data
            self.tableView.reloadData()
        }
        
        // Do any additional setup after loading the view.
    }
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
      //  navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    func setNavigationBarProperties(){
        var currentTheme:CTTheme!
        currentTheme = cricTracTheme.currentTheme
        //        navigationController!.navigationBar.barTintColor = currentTheme.topColor //UIColor(hex: topColor)
        self.contentViewForCommentCell.backgroundColor =  currentTheme.topColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let data = dataSource[indexPath.row]
        let aCell =  tableView.dequeueReusableCellWithIdentifier("commentcell", forIndexPath: indexPath) as! CommentTableViewCell
        aCell.parent = self

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
        } else {
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
                let imageName = "propic.png"
                let image = UIImage(named: imageName)
                aCell.userImage.image = image
            }else{
                if let imageURL = NSURL(string:proPic!){
                    aCell.userImage.kf_setImageWithURL(imageURL)
                }
            }
        })
        }

        
        
        aCell.selectionStyle = UITableViewCellSelectionStyle.None
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
    
    @IBAction func didTapClose(sender: AnyObject) {
        dismissViewControllerAnimated(true) {
            if self.postLikeCount < self.initialLikes{
                var likes = timelineData!.arrayObject![self.postIndex]["Likes"] as! [String:[String:String]]
                let keys =  likes.filter{key,val in
                    return val["OwnerID"]! == currentUser!.uid
                }.map{
                    return $0.0
                }
                
                if keys.count > 0 {
                    likes.removeValueForKey(keys[0])
                    timelineData![self.postIndex]["Likes"] = JSON(likes)
                }
            }
            if self.postLikeCount != self.initialLikes{
                self.refreshableParent?.refresh()
            }
        }
        
    }
    
    func deletebuttonTapped() {
        //        timelineData!.arrayObject?.removeAtIndex(index)
        //        timeLineTable.reloadData()
         //tableView.reloadData()
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//       
//            
//            let actionSheetController = UIAlertController(title: "", message: "Are you sure to delete the comment?", preferredStyle: .ActionSheet)
//            
//            // Create and add the Cancel action
//            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
//                // Just dismiss the action sheet
//                actionSheetController.dismissViewControllerAnimated(true, completion: nil)
//            }
//            actionSheetController.addAction(cancelAction)
//            
//            // Create and add first option action
//            let takePictureAction = UIAlertAction(title: "Delete", style: .Default) { action -> Void in
//               
//                let refreshAlert = UIAlertController(title: "Delete Comment", message: "Are you sure you want to delete this comment?", preferredStyle: UIAlertControllerStyle.Alert)
//                
//                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
//                    print("Handle Ok logic here")
//                   // self.deleteComment()
//                    
//                }))
//                
//                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
//                    print("Handle Cancel Logic here")
//                }))
//                
//                self.presentViewController(refreshAlert, animated: true, completion: nil)
//            }
//        
//            actionSheetController.addAction(takePictureAction)
//            
//            // We need to provide a popover sourceView when using it on iPad
//         //   actionSheetController.popoverPresentationController?.sourceView = sender as UIView
//            
//            // Present the AlertController
//            self.presentViewController(actionSheetController, animated: true, completion: nil)
//            
//            
//        
//    }
    
//    func deleteTapp() {
//        let refreshAlert = UIAlertController(title: "Delete Comment", message: "Are you sure you want to delete this comment?", preferredStyle: UIAlertControllerStyle.Alert)
//        
//        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
//            print("Handle Ok logic here")
//            // self.deleteComment()
//            
//        }))
//        
//        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
//            print("Handle Cancel Logic here")
//        }))
//        
//        self.presentViewController(refreshAlert, animated: true, completion: nil)
//    }
    
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
        
        if text ==  "\n"{ return false}
       
        
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
       
   
        let lines  =  textViewContent.characters.count/40
        let heightConstant = Int((self.textViewHeightConstraint.constant - 30)/18)
        
        if lines > heightConstant{
            if self.textViewHeightConstraint.constant < 102{
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.textViewHeightConstraint.constant = self.textViewHeightConstraint.constant+18
                })}
        }else if heightConstant > lines
        {
            self.textViewHeightConstraint.constant = self.textViewHeightConstraint.constant - 18
        }
        return true
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool{
        textView.clearPlaceHolder()
        return true
    }
    
//    @IBAction func didTapLikeButton(sender: UIButton) {
//        likeOrUnlike(postId)
//    }
    
    @IBAction func didTapLikeButton(sender: UIButton) {
        // network reachability test
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if !appDelegate.reachability.isReachable()  {
            let alert = UIAlertController(title: "", message: networkErrorMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        likeOrUnlike(postId, like: { (likeDict) in
            self.likeButton.titleLabel?.textColor = UIColor.whiteColor()
            self.postLikeCount += 1
            //self.likes.text = "\(self.postLikeCount) Likes"
             timelineData![self.postIndex]["Likes"] = JSON(likeDict)
        }) {
            self.removeLikeFromArray()
            self.likeButton.titleLabel?.textColor = UIColor.grayColor()
            self.postLikeCount -= 1
            //self.likes.text = "\(self.postLikeCount) Likes"
        }
    }
    
    func addLikeToDataArray(likeArray:[String:[String:String]]){
        
        //timelineData![index]["Likes"] = JSON(likeArray)
    }
    
    func removeLikeFromArray(){
        /*
         var likes = timelineData!.arrayObject![index]["Likes"] as! [String:[String:String]]
         let keys =  likes.filter{key,val in
         
         return val["OwnerID"]! == currentUser!.uid
         
         }.map{
         
         return $0.0
         }
         
         if keys.count > 0 {
         
         likes.removeValueForKey(keys[0])
         
         timelineData![index!]["Likes"] = JSON(likes)
         }
         */
        
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
