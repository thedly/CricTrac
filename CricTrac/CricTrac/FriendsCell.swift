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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.baseView.layer.cornerRadius = 10
        self.baseView.clipsToBounds = true
        self.baseView.backgroundColor = UIColor().darkerColorForColor(UIColor(hex: UIColor().hexFromUIColor(cricTracTheme.currentTheme.bottomColor)))
        
        self.baseView.alpha = 0.8
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
