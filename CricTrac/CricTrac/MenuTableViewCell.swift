//
//  MenuTableViewCell.swift
//  CricTrac
//
//  Created by Tejas Hedly on 28/07/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var menuLbl: UILabel!
    
    
    @IBOutlet weak var cellHighlight: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.cellHighlight.backgroundColor = UIColor(hex: "BB4440")
        }
        else
        {
            self.cellHighlight.backgroundColor = UIColor.clearColor()
        }
        
        // Configure the view for the selected state
    }
    
    func configureCell(menuItem:String) {
        self.menuLbl.text = menuItem
        
    }

}
