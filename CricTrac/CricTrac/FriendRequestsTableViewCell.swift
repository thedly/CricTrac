//
//  FriendRequestsTableViewCell.swift
//  CricTrac
//
//  Created by Tejas Hedly on 11/08/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class FriendRequestsTableViewCell: UITableViewCell {

    @IBOutlet weak var viewProfileBtn: UIButton!
    @IBOutlet weak var friendProfileImage: UIImageView!
    @IBOutlet weak var friendProfileName: UILabel!
    @IBOutlet weak var friendProfileTeamName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // MARK: - Methods
    
    func configureCell(friendName:String, friendTeamName:String,friendProfileImage:String){
        self.friendProfileName.text = friendName
        self.friendProfileTeamName.text = friendTeamName
    }
    

}
