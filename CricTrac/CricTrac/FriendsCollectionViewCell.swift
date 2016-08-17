//
//  FriendsCollectionViewCell.swift
//  CricTrac
//
//  Created by Tejas Hedly on 15/08/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class FriendsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var viewProfileBtn: UIButton!
    @IBOutlet weak var friendProfileImage: UIImageView!
    @IBOutlet weak var friendProfileName: UILabel!
    @IBOutlet weak var friendProfileTeamName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        friendProfileImage.layer.cornerRadius = friendProfileImage.frame.size.width/2
        friendProfileImage.clipsToBounds = true
    }
    
    // MARK: - Methods
    
    func configureCell(friendName:String, friendTeamName:String,friendProfileImage:String){
        self.friendProfileName.text = friendName
        //self.friendProfileTeamName.text = friendTeamName
    }

}
