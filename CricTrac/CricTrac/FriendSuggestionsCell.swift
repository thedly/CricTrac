//
//  FriendSuggestionsCell.swift
//  CricTrac
//
//  Created by Tejas Hedly on 10/10/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class FriendSuggestionsCell: UITableViewCell {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userCity: UILabel!
    @IBOutlet weak var userProfileView: UIImageView!
    @IBOutlet weak var AddFriendBtn: UIButton!
    private var _userObj: Profile!
    
    var friendId:String?

    override func awakeFromNib() {
        super.awakeFromNib()
        addTapGestureToUserName()

        // Initialization code
        self.baseView.layer.cornerRadius = 10
        self.baseView.clipsToBounds = true
        self.baseView.backgroundColor = UIColor().darkerColorForColor(UIColor(hex: UIColor().hexFromUIColor(cricTracTheme.currentTheme.bottomColor)))
        
        self.baseView.alpha = 0.8

        self.AddFriendBtn.userInteractionEnabled = true
    }
    
    func addTapGestureToUserName(){
        if let _ = userName{
            let gesture = UITapGestureRecognizer(target: self, action: #selector(FriendSuggestionsCell.didTapFriendName))
            userName.userInteractionEnabled = true
            userName.addGestureRecognizer(gesture)
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
    
    func configureCell(userProfileObject: Profile) {
        self._userObj = userProfileObject
        self.userName.text = userProfileObject.fullName
        self.userCity.text = userProfileObject.City
        //self.userTeam.text = userProfileObject.TeamName
        self.userProfileView.image = extractImages(userProfileObject.id)
    }
}
