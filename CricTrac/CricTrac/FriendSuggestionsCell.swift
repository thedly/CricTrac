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
    @IBOutlet weak var userTeam: UILabel!
    
    @IBOutlet weak var userProfileView: UIImageView!
    
    @IBOutlet weak var AddFriendBtn: UIButton!
    private var _userObj: Profile!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.baseView.layer.cornerRadius = 10
        self.baseView.clipsToBounds = true
        self.baseView.backgroundColor = UIColor().darkerColorForColor(UIColor(hex: bottomColor))
        self.baseView.alpha = 0.8
        self.AddFriendBtn.userInteractionEnabled = true
        
        
        
        //self.AddFriendBtn.addTarget(self, action: #selector(FriendSuggestionsCell.AddFriendBtnPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
    }

    
    func AddFriendBtnPressed(sender: UIButton) {
        
        
        if let loggedInUser = UserProfilesData.filter({ $0.id == currentUser?.uid }).first {
            
            let friendRequestData  = ["sentRequestData":
            
            ["City": _userObj.City, "Club": _userObj.TeamName, "Name": _userObj.fullName, "SentTo": _userObj.id, "SentDateTime": "\(currentTimeMillis())"],
            
            "ReceivedRequestData" : ["City": loggedInUser.City, "Club": loggedInUser.TeamName, "Name": loggedInUser.fullName, "ReceivedFrom": loggedInUser.id, "ReceievedDateTime": "\(currentTimeMillis())"]
            ]
            
            AddSentRequestData(friendRequestData, callback: { sentRequestId in
            print(sentRequestId)
            })
            
            
            
            //Send Friend Request
        }
        
        
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(userProfileObject: Profile) {
        
        self._userObj = userProfileObject
        
        self.userName.text = userProfileObject.fullName
        self.userTeam.text = userProfileObject.TeamName
        self.userProfileView.image = extractImages(userProfileObject.ProfileImageUrl)
        
        
        
        self.AddFriendBtn.addTarget(self, action: #selector(FriendSuggestionsCell.AddFriendBtnPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func extractImages(_imageUrl:String) -> UIImage {
        if _imageUrl != "" {
            return UserProfilesImages[_imageUrl]!
        }
        return UIImage(named: "User")!
    }

    

}
