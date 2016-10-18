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
    private var _userObj = [String:AnyObject]()
    
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
        
        var currentRequest  = self._userObj
        print(currentRequest)
        
        //Send Friend Request
        
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(userProfileObject: [String:AnyObject]) {
        
        self._userObj = userProfileObject
        
        var fullName = ""
        var fullTeamName = ""
        var fullImagePath = ""
        
        var currentProfile = userProfileObject
        
        if let fname = currentProfile["FirstName"], let lname = currentProfile["LastName"] {
            fullName = "\(fname) \(lname)"
        }
        
        if let teamName = currentProfile["TeamName"] {
            fullTeamName = "\(teamName)"
        }
        
        if let imapgePath = currentProfile["ProfileImageUrl"] {
            fullImagePath = "\(imapgePath)"
        }
        
        
        
        
        self.userName.text = fullName
        self.userTeam.text = fullTeamName
        self.userProfileView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: fullImagePath)!)!) //extractImages(fullImagePath)
        
        self.AddFriendBtn.addTarget(self, action: #selector(FriendSuggestionsCell.AddFriendBtnPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func extractImages(_imageUrl:String) -> UIImage {
        if _imageUrl != "" {
            return UserProfilesImages[_imageUrl]!
        }
        return UIImage(named: "User")!
    }


}
