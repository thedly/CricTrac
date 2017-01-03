//
//  SettingsViewCell.swift
//  CricTrac
//
//  Created by Tejas Hedly on 01/01/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

class SettingsViewCell: UITableViewCell {

    
    @IBOutlet weak var menuItemIcon: UIImageView!
    @IBOutlet weak var menuItemName: UILabel!
    @IBOutlet weak var menuItemDescription: UILabel!
    
    @IBOutlet weak var menuItemSelectedValue: UILabel!
    @IBOutlet weak var menuItemToggleSwitch: UISwitch!
    
    var IsSwitchVisible: Bool = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.backgroundColor = UIColor.clearColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
