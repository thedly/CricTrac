//
//  LikesTableViewCell.swift
//  CricTrac
//
//  Created by AIPL on 03/05/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

class LikesTableViewCell: UITableViewCell{

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var friendButton: UIButton!
    var parent:DeleteComment?
    
    var friendUserId:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       //  userImage.layer.cornerRadius = userImage.bounds.size.width/2
        self.friendButton.layer.cornerRadius = 10
         addTapGestureToUserName()
        parent?.deletebuttonTapped()
    }
    func addTapGestureToUserName(){
        if let _ = name{
            let gesture = UITapGestureRecognizer(target: self, action: #selector(LikesTableViewCell.didTapOwnerName))
            name.userInteractionEnabled = true
            name.addGestureRecognizer(gesture)
            
        }
    }
    func didTapOwnerName(){
            if  friendUserId != ""{
                getFriendProfileInfo(friendUserId, sucess: { (friendInfo) in
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
            dashBoard.friendId = friendUserId
            dashBoard.friendProfile = userInfo
        
        parentVC.presentViewController(dashBoard, animated: true) {}
            
        }
    }
    
    func moveToCoach(userInfo:[String : AnyObject]){
        if let parentVC = parent as? UIViewController{
            let dashBoard = viewControllerFrom("Main", vcid: "CoachDashboardViewController") as! CoachDashboardViewController
            dashBoard.friendId = friendUserId
            dashBoard.friendProfile = userInfo
            parentVC.presentViewController(dashBoard, animated: true) {}
        }
    }
    
    func moveToFan(userInfo:[String : AnyObject]){
        if let parentVC = parent as? UIViewController{
            let dashBoard = viewControllerFrom("Main", vcid: "FanDashboardViewController") as! FanDashboardViewController
            dashBoard.friendId = friendUserId
            dashBoard.friendProfile = userInfo
            parentVC.presentViewController(dashBoard, animated: true) {}
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
      
    @IBAction func didTapFriendButton(sender: UIButton) {
        
        if self.friendButton.titleLabel?.text == "Add Friend" {
            if friendUserId != "" {
                getProfileInfoById(friendUserId, sucessBlock: { FriendData in
                    let FriendObject = Profile(usrObj: FriendData)
                    getProfileInfoById((currentUser?.uid)!, sucessBlock: { data in
                        let loggedInUserObject = Profile(usrObj: data)
                        let sendFriendRequestData = SentFriendRequest()
                        sendFriendRequestData.City = FriendObject.City
                        sendFriendRequestData.Name = FriendObject.fullName
                        sendFriendRequestData.SentTo = FriendObject.id
                        sendFriendRequestData.SentDateTime = NSDate().getCurrentTimeStamp()
                        
                        let receiveFriendRequestData = ReceivedFriendRequest()
                        receiveFriendRequestData.City = loggedInUserObject.City
                        receiveFriendRequestData.Name = loggedInUserObject.fullName
                        receiveFriendRequestData.ReceivedFrom = loggedInUserObject.id
                        receiveFriendRequestData.ReceivedDateTime = NSDate().getCurrentTimeStamp()
                        
                        backgroundThread(background: {
                            AddSentRequestData(["sentRequestData": sendFriendRequestData.GetFriendRequestObject(sendFriendRequestData), "ReceivedRequestData": receiveFriendRequestData.getFriendRequestObject(receiveFriendRequestData)], callback: { data in
                                
                                dispatch_async(dispatch_get_main_queue(),{
                                    //self.searchedProfiles.removeAll()
                                  //  self.friendSearchTbl.reloadData()
                                    self.friendButton.setTitle("Pending", forState: .Normal)
                                    self.friendButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                                    
                                })
                            })
                        })
                    })
                })
            }
    }
}

}
