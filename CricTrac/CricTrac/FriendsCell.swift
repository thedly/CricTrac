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
    
    @IBOutlet weak var FriendProfileImage: UIImageView!
    @IBOutlet weak var FriendName: UILabel!
    @IBOutlet weak var FriendCity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.baseView.layer.cornerRadius = 10
        self.baseView.clipsToBounds = true
        self.baseView.backgroundColor = UIColor.blackColor()
        self.baseView.alpha = 0.3
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
