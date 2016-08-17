//
//  CollapsibleTableViewCell.swift
//  CricTrac
//
//  Created by Tejas Hedly on 14/08/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class CollapsibleTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var expandingAccessory: UIImageView!
    @IBOutlet weak var line1Label: UILabel!
    @IBOutlet weak var line2Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
