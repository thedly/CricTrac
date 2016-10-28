//
//  CurrentTeamsTableViewCell.swift
//  CricTrac
//
//  Created by Tejas Hedly on 23/10/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class CurrentTeamsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var teamName: UILabel!
    
    @IBOutlet weak var deleteTeamBtn: UIButton!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
