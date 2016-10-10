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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.baseView.layer.cornerRadius = 10
        self.baseView.clipsToBounds = true
        self.baseView.backgroundColor = UIColor().darkerColorForColor(UIColor(hex: bottomColor))
        self.baseView.alpha = 0.8
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
