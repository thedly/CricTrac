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
    @IBOutlet weak var post: UILabel!
    @IBOutlet weak var postOwnerCity: UILabel!

    @IBOutlet weak var likeCount: UIButton!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentCount: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
     @IBOutlet weak var postedDate: UILabel!
    
    
    var postId:String?
    var totalLikeCount = 0
    var index:Int?
    var currentUserHasLikedThePost = false
    var parent:Deletable?
    var postOwnerId:String?
    var postIndex = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        // Initialization code
        addTapGestureToUserName()
    }
    
    
    func addTapGestureToUserName(){
        
        if let _ = postOwnerName{
            let gesture = UITapGestureRecognizer(target: self, action: #selector(APostTableViewCell.didTapLabelName))
            postOwnerName.userInteractionEnabled = true
            postOwnerName.addGestureRecognizer(gesture)
        }
        
    }
    
    func didTapLabelName(){
        print("Working")
        
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
            dashBoard.friendProfile = userInfo
            parentVC.presentViewController(dashBoard, animated: true) {}
        }
        
    }
    
    func moveToFan(userInfo:[String : AnyObject]){
        
        if let parentVC = parent as? UIViewController{
            let dashBoard = viewControllerFrom("Main", vcid: "FanDashboardViewController") as! FanDashboardViewController
            dashBoard.friendProfile = userInfo
            parentVC.presentViewController(dashBoard, animated: true) {}
        }
    }
    
    
    @IBAction func DidTapLikeButton(sender: UIButton) {
        
        if let value = postId{
        
       likeOrUnlike(value, like: { (likeDict) in
        
        self.addLikeToDataArray(likeDict)
        self.likeButton.titleLabel?.textColor = UIColor.yellowColor()
        self.totalLikeCount += 1
        self.likeCount.setTitle("\(self.totalLikeCount) LIKES", forState: .Normal)
        self.currentUserHasLikedThePost = true
        
        }) {
            self.removeLikeFromArray()
            self.likeButton.titleLabel?.textColor = UIColor.grayColor()
            self.totalLikeCount -= 1
            self.likeCount.setTitle("\(self.totalLikeCount) LIKES", forState: .Normal)
            self.currentUserHasLikedThePost = false

        }
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
//        
//                let appearance = SCLAlertView.SCLAppearance(
//                    showCloseButton: false
//                )
//                
//                let alertView = SCLAlertView(appearance: appearance)
//                
//                alertView.addButton("OK", target:self, selector:#selector(APostTableViewCell.deletePostFromFB))
//                
//                alertView.addButton("Cancel", target:self, selector:#selector(APostTableViewCell.cancel))
//                
//                alertView.showNotice("Warning", subTitle: "All Data will be lost if you continue")
    }
    
    func showPostOptions(){
        
        let optionMenu = UIAlertController(title: nil, message: "SELECT ACTION", preferredStyle: .ActionSheet)
        
        // 2
        let deleteAction = UIAlertAction(title: "DELETE", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
           
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.addButton("OK", target:self, selector:#selector(APostTableViewCell.deletePostFromFB))
            
            alertView.addButton("Cancel", target:self, selector:#selector(APostTableViewCell.cancel))
            
            alertView.showNotice("Warning", subTitle: "All Data will be lost if you continue")
        })
        let saveAction = UIAlertAction(title: "EDIT", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.presentEditablePost()
            
        })
        
        //
        let cancelAction = UIAlertAction(title: "CANCEL", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        // 4
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        // 5
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
            setIsDeletedToOne(value)
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
