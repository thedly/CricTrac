//
//  FriendRequestsCell.swift
//  CricTrac
//
//  Created by Tejas Hedly on 10/10/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class FriendRequestsCell: UITableViewCell {
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var FriendProfileImage: UIImageView!
    @IBOutlet weak var FriendName: UILabel!
    @IBOutlet weak var FriendCity: UILabel!
    
    
    @IBOutlet weak var baseView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.baseView.layer.cornerRadius = 10
        self.baseView.clipsToBounds = true
//        self.baseView.backgroundColor = UIColor().darkerColorForColor(UIColor(hex: UIColor().hexFromUIColor(cricTracTheme.currentTheme.bottomColor)))
//        
//        self.baseView.alpha = 0.8
        
        
        self.confirmBtn.userInteractionEnabled = true
        
        self.rejectBtn.userInteractionEnabled = true
        
        self.cancelBtn.userInteractionEnabled = true
        
        self.rejectBtn.layer.borderWidth = 2.0
        
        self.cancelBtn.layer.cornerRadius = 10
        self.rejectBtn.layer.cornerRadius = 10
        self.confirmBtn.layer.cornerRadius = 10
        
        self.rejectBtn.layer.borderColor = UIColor.whiteColor().CGColor
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
