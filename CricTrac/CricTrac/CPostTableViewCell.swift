//
//  CPostTableViewCell.swift
//  CricTrac
//
//  Created by AIPL on 02/05/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit
import SwiftyJSON

class CPostTableViewCell: UITableViewCell {
    @IBOutlet weak var postOwnerName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var ownerCity: UILabel!
    @IBOutlet weak var comments: UIButton!
    @IBOutlet weak var likes: UIButton!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var delCommentBtn: UIButton!
    
    var postOwnerId:String?
    var parent:Deletable?
    var postId:String?
    var postLikeCount = 0
    
    var postIndex = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addTapGestureToUserName()
    }
   
    
    func addTapGestureToUserName(){
        if let _ = postOwnerName{
            let gesture = UITapGestureRecognizer(target: self, action: #selector(CPostTableViewCell.didTapOwnerName))
            postOwnerName.userInteractionEnabled = true
            postOwnerName.addGestureRecognizer(gesture)
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
  
    
    func moveToPlayer(userInfo:[String : AnyObject]){
        //if let parentVC = parent as? UIViewController{
            let dashBoard = viewControllerFrom("Main", vcid: "UserDashboardViewController") as! UserDashboardViewController
            dashBoard.friendId = postOwnerId
            dashBoard.friendProfile = userInfo
            //parentVC.presentViewController(dashBoard, animated: true) {}
        
            self.window?.rootViewController?.presentViewController(dashBoard, animated: true) {}
            print(postOwnerId)
        //}
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
    
    @IBAction func didTapLikeButton(sender: UIButton) {
        // network reachability test
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if !appDelegate.reachability.isReachable()  {
            let alert = UIAlertController(title: "", message: networkErrorMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            let parentVC = parent as? CommentsViewController
            parentVC!.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        likeOrUnlike(postId!, like: { (likeDict) in
            //self.likeLabel.textColor = UIColor.whiteColor()
            self.postLikeCount += 1
            //self.likes.text = "\(self.postLikeCount) Likes"
            timelineData![self.postIndex]["Likes"] = JSON(likeDict)
        }) {
            //self.removeLikeFromArray()
            //self.likeLabel.textColor = UIColor.grayColor()
            self.postLikeCount -= 1
            //self.likes.text = "\(self.postLikeCount) Likes"
        }
    }
    
//    @IBAction func didTapClose(sender: AnyObject) {
//        dismissViewControllerAnimated(true) {
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
//        }
//        
//    }
//    
//    func deletebuttonTapped() {
//        
//    }
    
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


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
