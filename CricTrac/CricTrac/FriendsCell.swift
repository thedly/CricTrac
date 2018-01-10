//
//  FriendsCell.swift
//  CricTrac
//
//  Created by Tejas Hedly on 25/09/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class FriendsCell: UITableViewCell {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var UnfriendBtn: UIButton!
    @IBOutlet weak var FriendProfileImage: UIImageView!
    @IBOutlet weak var FriendName: UILabel!
    @IBOutlet weak var FriendCity: UILabel!
    @IBOutlet weak var friendRole: UILabel!
    
    var friendId:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addTapGestureToUserName()
        FriendProfileImage.layer.cornerRadius = FriendProfileImage.frame.size.width/2
        FriendProfileImage.clipsToBounds = true
        
        self.baseView.layer.cornerRadius = 10
        self.baseView.clipsToBounds = true

    }
    
    @IBAction func friendImageTapped(sender: AnyObject) {
        didTapFriendName()
    }
    
    func addTapGestureToUserName(){
        if let _ = FriendName{
            let gesture = UITapGestureRecognizer(target: self, action: #selector(FriendsCell.didTapFriendName))
            FriendName.userInteractionEnabled = true
            FriendName.addGestureRecognizer(gesture)
        }
    }
    
    func didTapFriendName(){
        if friendId != nil{
            getFriendProfileInfo(friendId, sucess: { (friendInfo) in
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
        let dashBoard = viewControllerFrom("Main", vcid: "UserDashboardViewController") as! UserDashboardViewController
        dashBoard.friendId = friendId
        dashBoard.friendProfile = userInfo
        self.window?.rootViewController?.presentViewController(dashBoard, animated: true) {}
    }
    
    func moveToCoach(userInfo:[String : AnyObject]){
        let dashBoard = viewControllerFrom("Main", vcid: "CoachDashboardViewController") as! CoachDashboardViewController
        dashBoard.friendId = friendId
        dashBoard.friendProfile = userInfo
        self.window?.rootViewController?.presentViewController(dashBoard, animated: true) {}
    }
    
    func moveToFan(userInfo:[String : AnyObject]){
        let dashBoard = viewControllerFrom("Main", vcid: "FanDashboardViewController") as! FanDashboardViewController
        dashBoard.friendId = friendId
        dashBoard.friendProfile = userInfo
        self.window?.rootViewController?.presentViewController(dashBoard, animated: true) {}
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
