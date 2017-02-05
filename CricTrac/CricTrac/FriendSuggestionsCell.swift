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
       
        self.AddFriendBtn.userInteractionEnabled = true
        
        self.baseView.backgroundColor = UIColor.blackColor()
        self.baseView.alpha = 0.3
        
        //self.AddFriendBtn.addTarget(self, action: #selector(FriendSuggestionsCell.AddFriendBtnPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
    }

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(userProfileObject: Profile) {
        
        self._userObj = userProfileObject
        
        self.userName.text = userProfileObject.fullName
//        self.userTeam.text = userProfileObject.TeamName
        self.userProfileView.image = extractImages(userProfileObject.id)
        
        
        
    }
    
    

    

}
