//
//  APostTableViewCell.swift
//  CricTrac
//
//  Created by Renjith on 9/19/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import SwiftyJSON
import SCLAlertView

class APostTableViewCell: UITableViewCell {

    @IBOutlet weak var postOwnerName: UILabel!
    @IBOutlet weak var postOwnerPic: UIImageView!
    @IBOutlet weak var post: UILabel!
    @IBOutlet weak var postOwnerCity: UILabel!
    @IBOutlet weak var likeCount: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentCount: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var postedDate: UILabel!
    
    @IBOutlet weak var commentButton: UIButton!
    var postId:String?
    var totalLikeCount = 0
    var index:Int?
    var currentUserHasLikedThePost = false
    var parent:Deletable?
    var postOwnerId:String?
    var postIndex = 0
    var totalCommentCount = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addTapGestureToUserName()
    }
    
    func addTapGestureToUserName(){
        if let _ = postOwnerName{
            let gesture = UITapGestureRecognizer(target: self, action: #selector(APostTableViewCell.didTapOwnerName))
            postOwnerName.userInteractionEnabled = true
            postOwnerName.addGestureRecognizer(gesture)
        }
        
        if let _ = post{
            let gesture = UITapGestureRecognizer(target: self, action: #selector(APostTableViewCell.didTapPost))
            post.userInteractionEnabled = true
            post.addGestureRecognizer(gesture)
        }
       
    }
    
    func didTapOwnerName(){
        if postOwnerName.text != "CricTrac" {
            if  postOwnerId != nil{
                getFriendProfileInfo(postOwnerId, sucess: { (friendInfo) in
                    if let friendType = friendInfo["UserProfile"] as? String{
                        switch friendType{
                            case "Player": self.moveToPlayer(friendInfo)
                            case "Coach": self.moveToCoach(friendInfo)
                            case "Cricket Fan": self.moveToFan(friendInfo)
                            default: break
                        }
                    }
                })
            }
        }
    }
    
    func didTapPost(){
        if  post != nil{
            if let parentVC = parent as? UIViewController{
                let commentPage = viewControllerFrom("Main", vcid: "CommentsViewController") as! CommentsViewController
                commentPage.postId = postId!
                parentVC.presentViewController(commentPage, animated: true) {}
            }
        }
    }
    
    func moveToPlayer(userInfo:[String : AnyObject]){
        if let parentVC = parent as? UIViewController{
            let dashBoard = viewControllerFrom("Main", vcid: "UserDashboardViewController") as! UserDashboardViewController
            dashBoard.friendId = postOwnerId
            dashBoard.friendProfile = userInfo
            parentVC.presentViewController(dashBoard, animated: true) {}
        }
    }

    func moveToCoach(userInfo:[String : AnyObject]){
        if let parentVC = parent as? UIViewController{
            let dashBoard = viewControllerFrom("Main", vcid: "CoachDashboardViewController") as! CoachDashboardViewController
            dashBoard.friendId = postOwnerId
            dashBoard.friendProfile = userInfo
            parentVC.presentViewController(dashBoard, animated: true) {}
        }
    }
    
    func moveToFan(userInfo:[String : AnyObject]){
        if let parentVC = parent as? UIViewController{
            let dashBoard = viewControllerFrom("Main", vcid: "FanDashboardViewController") as! FanDashboardViewController
            dashBoard.friendId = postOwnerId
            dashBoard.friendProfile = userInfo
            parentVC.presentViewController(dashBoard, animated: true) {}
        }
    }
    
    @IBAction func didTapCommentCountButtonTapped(sender:UIButton) {
        if totalCommentCount != 0 {
            if let parentVC = parent as? UIViewController {
                let commentPage  = viewControllerFrom("Main", vcid: "CommentsViewController") as! CommentsViewController
                commentPage.postId = postId!
                parentVC.presentViewController(commentPage, animated: true){}
                
            }
        }
        
    }
    
    @IBAction func DidTapLikeCountButton(sender: UIButton) {
        if totalLikeCount != 0 {
            if let parentVC = parent as? UIViewController{
                let likePage = viewControllerFrom("Main", vcid: "LikesViewController") as! LikesViewController
                 likePage.postID = postId!
                parentVC.presentViewController(likePage, animated: true) {}
            }
        }
    }
    
    @IBAction func DidTapLikeButton(sender: UIButton) {
        // network reachability test
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if !appDelegate.reachability.isReachable()  {
            let alert = UIAlertController(title: "", message: networkErrorMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            let parentVC = parent as? TimeLineViewController
            parentVC!.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
//        if currentUserHasLikedThePost {
//            self.totalLikeCount -= 1
//            self.likeButton.titleLabel?.textColor = UIColor.blackColor()
//            self.likeButton.setImage(UIImage(named: "Like-100"), forState: UIControlState.Normal)
//            self.likeCount.setTitle("\(totalLikeCount) Likes", forState: .Normal)
//            currentUserHasLikedThePost = false
//        }
//        else {
//            self.totalLikeCount += 1
//            self.likeButton.titleLabel?.textColor = UIColor.whiteColor()
//            self.likeButton.setImage(UIImage(named: "Like-Filled"), forState: UIControlState.Normal)
//            self.likeCount.setTitle("\(totalLikeCount) Likes", forState: .Normal)
//            currentUserHasLikedThePost = true
//        }
        
        //likeOrUnlike(postId!)
        
        if let value = postId{
            likeOrUnlike(value, like: { (likeDict) in
                self.addLikeToDataArray(likeDict)
                //self.likeButton.titleLabel?.textColor = UIColor.yellowColor()
                self.likeButton.titleLabel?.textColor = UIColor.whiteColor()
                self.likeButton.setImage(UIImage(named: "Like-Filled"), forState: UIControlState.Normal)
                self.totalLikeCount += 1
                self.likeCount.setTitle("\(self.totalLikeCount) LIKES", forState: .Normal)
                self.currentUserHasLikedThePost = true
            }) {
                self.removeLikeFromArray()
                //self.likeButton.titleLabel?.textColor = UIColor.grayColor()
                self.likeButton.titleLabel?.textColor = UIColor.blackColor()
                self.likeButton.setImage(UIImage(named: "Like-100"), forState: UIControlState.Normal)
                self.totalLikeCount -= 1
                self.likeCount.setTitle("\(self.totalLikeCount) LIKES", forState: .Normal)
                self.currentUserHasLikedThePost = false
            }
        }
    }
    
  
    @IBAction func didTapCommentButton(sender: UIButton) {
       
        if let parentVC = parent as? UIViewController{
            let commentPage = viewControllerFrom("Main", vcid: "CommentsViewController") as! CommentsViewController
            commentPage.postId = postId!
            parentVC.presentViewController(commentPage, animated: true) {}
        }
        
        
    }
    func removeLikeFromArray(){
        var likes = timelineData!.arrayObject![index!]["Likes"] as! [String:[String:String]]
        let keys =  likes.filter{key,val in
            return val["OwnerID"]! == currentUser!.uid
            }.map{
                return $0.0
        }
        
        if keys.count > 0 {
            likes.removeValueForKey(keys[0])
            timelineData![index!]["Likes"] = JSON(likes)
        }
    }
    
    func addLikeToDataArray(likeArray:[String:[String:String]]){
        timelineData![index!]["Likes"] = JSON(likeArray)
    }
    
    
    @IBAction func deletePost(sender: UIButton){
        showPostOptions()
    }
    
    func showPostOptions(){
        let optionMenu = UIAlertController(title: nil, message: "Select Action", preferredStyle: .ActionSheet)
       
        let deleteAlert = UIAlertController(title: "Delete Post", message: "Are you sure you want to delete this post?", preferredStyle: UIAlertControllerStyle.Alert)

    
        if postOwnerName.text != "CricTrac" {
            let saveAction = UIAlertAction(title: "Edit", style: .Default, handler: {
                (alert: UIAlertAction!) -> Void in
                self.presentEditablePost()
            })
            optionMenu.addAction(saveAction)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
              deleteAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!)-> Void in
                self.deletePostFromFB()
                print("Handle Cancel Logic here")
               }))
            
              deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!)-> Void in
                
                         self.cancel()
                          print("Handle Cancel Logic here")
              }))
            
              let parentVc = self.parent as? UIViewController
               parentVc!.presentViewController(deleteAlert, animated: true, completion: nil)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        if let parentVc = parent as? UIViewController{
            parentVc.presentViewController(optionMenu, animated: true, completion: nil)
        }
    }
    
    func presentEditablePost(){
        let newPost = viewControllerFrom("Main", vcid: "NewPostViewController") as! NewPostViewController
        newPost.sendPostDelegate = (self.parent as! PostSendable)
        newPost.modalPresentationStyle = .OverCurrentContext
        newPost.editingPost = self.post.text
        newPost.postIndex = postIndex
        if let val = postId{
           newPost.postId = val
        }
        if let parentVC = self.parent as? UIViewController{
            parentVC.presentViewController(newPost, animated: true, completion: nil)
        }
    }
    
    func deletePostFromFB(){
        if let value = postId{
            deleteSelectedPost(value)
        }
        parent?.deletePost(index!)
    }
    
    func cancel(){
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
