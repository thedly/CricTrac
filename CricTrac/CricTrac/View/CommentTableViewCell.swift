//
//  CommentTableViewCell.swift
//  CricTrac
//
//  Created by Renjith on 25/12/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var commentText: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var commentDate: UILabel!
    @IBOutlet weak var delCommentBtn: UIButton!
    
    var commentID:String?
    var postID:String?
    var parent:DeleteComment?
    var ownerId:String?
    var postIndex = 0
    
    @IBAction func deletebuttonTapped(sender: AnyObject) {
      
        let deleteAlert = UIAlertController(title: "Delete Comment", message: "Are you sure you want to delete this comment?", preferredStyle: UIAlertControllerStyle.Alert)
        
        deleteAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
            //delete comment
            if let value = self.commentID {
                delComment(self.postID!,commentId: value)
            }
            
            self.parent?.deletebuttonTapped()
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
            //print("Handle Cancel Logic here")
        }))
        
        if let parentVc = parent as? UIViewController{
            parentVc.presentViewController(deleteAlert, animated: true, completion: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addTapGestureToUserName()
        // Initialization code
        parent?.deletebuttonTapped()
    }
    
    func addTapGestureToUserName(){
        if let _ = userName{
            let gesture = UITapGestureRecognizer(target: self, action: #selector(CommentTableViewCell.didTapOwnerName))
            userName.userInteractionEnabled = true
            userName.addGestureRecognizer(gesture)
        }
    }
    
    @IBAction func ownerImageTapped(sender: AnyObject) {
        didTapOwnerName()
    }
    
    func didTapOwnerName(){
        if ownerId != nil{
            getFriendProfileInfo(ownerId, sucess: { (friendInfo) in
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
            dashBoard.friendId = ownerId
            dashBoard.friendProfile = userInfo
        
        parentVC.presentViewController(dashBoard, animated: true) {}
           // self.window?.rootViewController?.presentViewController(dashBoard, animated: true) {}

        }
    }
    
    func moveToCoach(userInfo:[String : AnyObject]){
        if let parentVC = parent as? UIViewController{
            let dashBoard = viewControllerFrom("Main", vcid: "CoachDashboardViewController") as! CoachDashboardViewController
            dashBoard.friendId = ownerId
            dashBoard.friendProfile = userInfo
            parentVC.presentViewController(dashBoard, animated: true) {}
        }
    }
    
    func moveToFan(userInfo:[String : AnyObject]){
        if let parentVC = parent as? UIViewController{
            let dashBoard = viewControllerFrom("Main", vcid: "FanDashboardViewController") as! FanDashboardViewController
            dashBoard.friendId = ownerId
            dashBoard.friendProfile = userInfo
            parentVC.presentViewController(dashBoard, animated: true) {}
        }
    }

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
