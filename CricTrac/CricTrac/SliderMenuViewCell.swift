//
//  SliderMenuViewCell.swift
//  CricTrac
//
//  Created by Tejas Hedly on 26/12/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class SliderMenuViewCell: UITableViewCell {

    @IBOutlet weak var menuIcon: UIImageView!
    
    @IBOutlet weak var menuName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor().darkerColorForColor(UIColor(hex: topColor))
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}