//
//  FriendRequestsCell.swift
//  CricTrac
//
//  Created by Tejas Hedly on 10/10/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class FriendRequestsCell: UITableViewCell {
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var FriendProfileImage: UIImageView!
    @IBOutlet weak var FriendName: UILabel!
    @IBOutlet weak var FriendCity: UILabel!
    @IBOutlet weak var FriendRole: UILabel!
    
    var friendId:String?
    var parent:DeleteComment?
    
    @IBOutlet weak var baseView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        addTapGestureToUserName()
        parent?.deletebuttonTapped()
        
        FriendProfileImage.layer.cornerRadius = FriendProfileImage.frame.size.width/2
        FriendProfileImage.clipsToBounds = true

        self.baseView.layer.cornerRadius = 10
        self.baseView.clipsToBounds = true
        self.confirmBtn.userInteractionEnabled = true
        self.rejectBtn.userInteractionEnabled = true
        self.cancelBtn.userInteractionEnabled = true
        self.rejectBtn.layer.borderWidth = 2.0
        self.cancelBtn.layer.cornerRadius = 10
        self.rejectBtn.layer.cornerRadius = 10
        self.confirmBtn.layer.cornerRadius = 10
        self.rejectBtn.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    @IBAction func friendImageTapped(sender: AnyObject) {
        didTapFriendName()
    }
    func addTapGestureToUserName(){
        if let _ = FriendName{
            let gesture = UITapGestureRecognizer(target: self, action: #selector(FriendRequestsCell.didTapFriendName))
            FriendName.userInteractionEnabled = true
            FriendName.addGestureRecognizer(gesture)
        }
    }
    
    func didTapFriendName(){
        if friendId != nil{
            getFriendProfileInfo(friendId, sucess: { (friendInfo) in
                if friendInfo["Celebrity"] != nil && friendInfo["Celebrity"] as? String != "-" {
                    self.moveToCelebrity(friendInfo)
                }
                else {
                    if let friendType = friendInfo["UserProfile"] as? String{
                        switch friendType{
                        case "Player": self.moveToPlayer(friendInfo)
                        case "Coach": self.moveToCoach(friendInfo)
                        case "Cricket Fan": self.moveToFan(friendInfo)
                        default: break
                        }
                    }
                }
            })
        }
    }
    
    func moveToCelebrity(userInfo:[String : AnyObject]){
        let dashBoard = viewControllerFrom("Main", vcid: "CelebrityDashboardViewController") as! CelebrityDashboardViewController
        dashBoard.friendId = friendId
        dashBoard.friendProfile = userInfo
        if let parentVc = parent as? UIViewController{
            parentVc.presentViewController(dashBoard, animated: true, completion: nil)
        }
        else{
            self.window?.rootViewController?.presentViewController(dashBoard, animated: true) {}
        }
    }
    
    func moveToPlayer(userInfo:[String : AnyObject]){
        let dashBoard = viewControllerFrom("Main", vcid: "UserDashboardViewController") as! UserDashboardViewController
        dashBoard.friendId = friendId
        dashBoard.friendProfile = userInfo
       // self.window?.rootViewController?.presentViewController(dashBoard, animated: true) {}
        if let parentVc = parent as? UIViewController{
            parentVc.presentViewController(dashBoard, animated: true, completion: nil)
        }
        else{
            self.window?.rootViewController?.presentViewController(dashBoard, animated: true) {}
        }
    }
    
    func moveToCoach(userInfo:[String : AnyObject]){
        let dashBoard = viewControllerFrom("Main", vcid: "CoachDashboardViewController") as! CoachDashboardViewController
        dashBoard.friendId = friendId
        dashBoard.friendProfile = userInfo
       // self.window?.rootViewController?.presentViewController(dashBoard, animated: true) {}
        if let parentVc = parent as? UIViewController{
            parentVc.presentViewController(dashBoard, animated: true, completion: nil)
        }
        else{
            self.window?.rootViewController?.presentViewController(dashBoard, animated: true) {}
        }
    }
    
    func moveToFan(userInfo:[String : AnyObject]){
        let dashBoard = viewControllerFrom("Main", vcid: "FanDashboardViewController") as! FanDashboardViewController
        dashBoard.friendId = friendId
        dashBoard.friendProfile = userInfo
        //self.window?.rootViewController?.presentViewController(dashBoard, animated: true) {}
        if let parentVc = parent as? UIViewController{
            parentVc.presentViewController(dashBoard, animated: true, completion: nil)
        }
        else{
            self.window?.rootViewController?.presentViewController(dashBoard, animated: true) {}
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
