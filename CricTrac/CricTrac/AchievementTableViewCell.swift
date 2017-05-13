//
//  AchievementTableViewCell.swift
//  CricTrac
//
//  Created by Sajith Kumar on 13/05/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

class AchievementTableViewCell: UITableViewCell {

    @IBOutlet weak var achievementNames: UILabel!
    @IBOutlet weak var achievementButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
